import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/model/location_model.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

enum ConnectionState {
  disconnected,
  connecting,
  connected,
}

class SignalR {
  static final SignalR _instance = SignalR._internal();
  static SignalR get instance => _instance;
  SignalR._internal();

  static late HubConnection connection;

  static final Logger _logger = Logger("SignalR: ");

  static bool _autoReconnect = false;

  /// Describes the current state of the HubConnection to the server.
  static Rx<ConnectionState> connectionState = ConnectionState.disconnected.obs;

  static const host =
      "https://tourism-smart-transportation-api.azurewebsites.net";

  final String _hubUrl = "$host/hub";

  /// Initiate a connection to the server
  void start() async {
    _autoReconnect = true;
    _openConnection();
  }

  /// Stops the connection
  void stop() {
    _autoReconnect = false;
    connection.stop();
  }

  void _openConnection() async {
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

      changeState(ConnectionState.disconnected);
    });
    connection.onreconnecting(({error}) {
      Utils.showToast('Mất kết nối đến server');
      debugPrint("Hyper SignalR: Onreconnecting called");

      changeState(ConnectionState.disconnected);

      connection.stop();
      _openConnection();
    });
    connection.onreconnected(({connectionId}) {
      debugPrint("Hyper SignalR: onreconnected called");

      changeState(ConnectionState.connected);
    });

    if (connection.state != HubConnectionState.Connected) {
      try {
        await connection.start();

        changeState(ConnectionState.connected);

        debugPrint('Hyper SignalR: Connected (${connection.connectionId})');
        Utils.showToast('Kết nối tới server thành công');
      } catch (e) {
        if (_autoReconnect) {
          debugPrint('Hyper SignalR: Connecting again');

          await Future.delayed(const Duration(seconds: 1));

          Utils.showToast('Đang kết nối lại');

          _openConnection();
        }
      }
    }

    _listen();
  }

  void changeState(ConnectionState value) {
    connectionState.value = value;
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
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.feedBack);
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
    debugPrint('Hyper SignalR: Finding Driver - $data');
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
