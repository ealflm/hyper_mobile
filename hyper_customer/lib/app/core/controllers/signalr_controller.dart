import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/model/location_model.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter/services.dart';

enum HubState {
  disconnected,
  connecting,
  connected,
}

class SignalR {
  static final SignalR _instance = SignalR._internal();
  static SignalR get instance => _instance;
  SignalR._internal();

  late HubConnection connection;

  final Logger _logger = Logger("SignalR: ");

  bool _autoReconnect = false;

  /// Describes the current state of the HubConnection to the server.
  Rx<HubState> hubState = HubState.disconnected.obs;

  final String _hubUrl =
      "https://tourism-smart-transportation-api.azurewebsites.net/hub";

  // Handle on resume
  _handleAppLifecycleState() {
    AppLifecycleState? lastLifecyleState;
    SystemChannels.lifecycle.setMessageHandler((message) async {
      switch (message) {
        case "AppLifecycleState.paused":
          lastLifecyleState = AppLifecycleState.paused;
          break;
        case "AppLifecycleState.inactive":
          lastLifecyleState = AppLifecycleState.inactive;
          break;
        case "AppLifecycleState.resumed":
          lastLifecyleState = AppLifecycleState.resumed;
          break;
        default:
      }

      if (lastLifecyleState == AppLifecycleState.resumed) {
        debugPrint('SignalR: (App State) $message');
        if (_autoReconnect &&
            connection.state != HubConnectionState.Connected) {
          debugPrint(
              'SignalR: (Open connect on resume) Current State = $lastLifecyleState');

          Utils.showToast('Đang kết nối lại');
          _retryUntilSuccessfulConnection();
        }
      }

      return message;
    });
  }

  /// Initiate a connection to the server
  void start() async {
    _autoReconnect = true;
    _handleAppLifecycleState();
    _retryUntilSuccessfulConnection();
  }

  /// Stops the connection
  void stop() {
    _autoReconnect = false;
    connection.stop();
  }

  Future<void> _openConnection() async {
    if (hubState.value == HubState.connected) return;

    var token = TokenManager.instance.token;

    final httpConnectionOptions = HttpConnectionOptions(
        logger: _logger,
        logMessageContent: true,
        accessTokenFactory: () async {
          return token;
        });

    connection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: httpConnectionOptions,
        )
        .withAutomaticReconnect(retryDelays: [1000])
        .configureLogging(_logger)
        .build();

    connection.onclose(({error}) {
      Utils.showToast('Mất kết nối đến server');
      _retryUntilSuccessfulConnection();

      changeState(HubState.disconnected);
    });
    connection.onreconnecting(({error}) {
      Utils.showToast('Mất kết nối đến server');
      debugPrint("SignalR: Onreconnecting called");

      changeState(HubState.disconnected);

      connection.stop();
      _retryUntilSuccessfulConnection();
    });
    connection.onreconnected(({connectionId}) {
      debugPrint("SignalR: onreconnected called");

      changeState(HubState.connected);
    });

    if (connection.state != HubConnectionState.Connected) {
      await connection.start();
      hubState.value = HubState.connected;
    }

    _listen();
  }

  final delayTime = 3;
  bool _onReconnect = false;

  void _retryUntilSuccessfulConnection() async {
    if (_onReconnect) return;
    _onReconnect = true;

    while (true) {
      try {
        await _openConnection();

        if (connection.state == HubConnectionState.Connected) {
          Utils.showToast('Kết nối thành công');
          _onReconnect = false;
          return;
        }
      } catch (e) {
        if (!_autoReconnect) return;
        Utils.showToast('Kết nối tới server thất bại');
      }

      await Future.delayed(Duration(seconds: delayTime));
      Utils.showToast('Đang kết nối lại');
    }
  }

  void changeState(HubState value) {
    hubState.value = value;
  }

  void _listen() {
    connection.on("BookingResponse", _bookingResponse);
    connection.on("DriverArrived", _driverArrived);
    connection.on("DriverPickedUp", _driverPickedUp);
    connection.on("CompletedBooking", _completedBooking);
  }

  void _driverArrived(List<Object>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.arrived);
  }

  void _bookingResponse(List<Object>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    var map = parameters?[0] as Map<String, dynamic>;
    if (map['statusCode'] == 200) {
      bookingDirectionController.changeState(BookingState.coming);
    } else if (map['statusCode'] == 210) {
      bookingDirectionController.changeState(BookingState.select);
    } else {
      bookingDirectionController.changeState(BookingState.failed);
    }
  }

  void _driverPickedUp(List<Object>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.pickedUp);
  }

  void _completedBooking(List<Object>? parameters) {
    debugPrint('SignalR: Completed Booking');

    Get.offAllNamed(Routes.MAIN);
    Get.toNamed(Routes.FEEDBACK_DRIVER);
  }

  Future<List<LatLng>> getDriverInfos(LatLng location) async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var data = {
      'Id': customerId,
      'Latitude': location.latitude,
      'Longitude': location.longitude,
    };

    debugPrint('Nam: ${jsonEncode(data)}');

    String? str = await connection.invoke(
      "GetDriversListMatching",
      args: [jsonEncode(data)],
    ) as String;

    List<dynamic> list = jsonDecode(str);

    List<LatLng> result = <LatLng>[];

    for (var item in list) {
      result.add(LatLng(item['Latitude'], item['Longitude']));
    }

    return result;
  }

  Future<void> findDriver(LocationModel locationModel) async {
    var data = jsonEncode(locationModel.toJson());
    connection.invoke("FindDriver", args: [data, 'true']);
    debugPrint('SignalR: Finding Driver - $data');
  }

  Future<void> cancelBooking() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    connection.invoke(
      "CancelBooking",
      args: [customerId],
    );
  }

  Future<void> canceledFinding() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    debugPrint('CanceledFinding: $customerId');

    connection.invoke(
      "CanceledFinding",
      args: [customerId],
    );
    debugPrint('CanceledFinding End: $customerId');
  }
}
