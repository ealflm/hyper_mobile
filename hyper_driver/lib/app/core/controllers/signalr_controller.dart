import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/model/driver_response_model.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../routes/app_pages.dart';

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

  // final String _hubUrl =
  //     "https://tourism-smart-transportation-api.azurewebsites.net/hub";
  final String _hubUrl = "https://localhost:5001/hub";

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
          _retryUntilSuccessfulConnection();
        }
      }

      return message;
    });
  }

  /// Initiate a connection to the server
  void start() async {
    if (hubState.value == HubState.connected) return;
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
      debugPrint('Mất kết nối đến server');
      _retryUntilSuccessfulConnection();

      changeState(HubState.disconnected);
    });
    connection.onreconnecting(({error}) {
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

  final delayTime = 1;
  bool _onReconnect = false;

  void _retryUntilSuccessfulConnection() async {
    if (hubState.value == HubState.connected) return;
    if (_onReconnect) return;
    _onReconnect = true;

    while (true) {
      try {
        await _openConnection();

        if (connection.state == HubConnectionState.Connected) {
          debugPrint('SignalR: Kết nối thành công');
          _onReconnect = false;
          return;
        }
      } catch (e) {
        if (!_autoReconnect) return;
        debugPrint('SignalR: Kết nối tới server thất bại');
      }

      await Future.delayed(Duration(seconds: delayTime));
      debugPrint('SignalR: Đang kết nối lại');
    }
  }

  void changeState(HubState value) {
    hubState.value = value;
  }

  void _listen() {
    connection.on("BookingRequest", _bookingRequest);
    connection.on("CanceledBooking", _canceledBooking);
    connection.on("FindingOut", _findingOut);
    connection.on("DriverNotResponse", _driverNotResponse);
  }

  void _driverNotResponse(List<Object>? parameters) {
    closeDriver();

    Get.offAllNamed(Routes.MAIN);
  }

  void _canceledBooking(List<Object>? parameters) {
    debugPrint('SignalR: Canceled booking');

    Get.offAllNamed(Routes.MAIN);
  }

  void _findingOut(List<Object>? parameters) {
    debugPrint('SignalR: Finding out');

    Get.offAllNamed(Routes.MAIN);
  }

  void _bookingRequest(List<Object>? parameters) async {
    debugPrint('SignalR: Booking request');

    var mapper = parameters?[0] as Map<String, dynamic>;
    var driver = jsonEncode(DriverResponseModel.fromJson(mapper).toJson());

    var result = await Get.toNamed(Routes.BOOKING_REQUEST);

    if (result == 1) {
      await connection.invoke(
        "CheckAcceptedRequest",
        args: [driver, "1"],
      );
      Get.offAllNamed(Routes.PICK_UP);
    } else if (result == 0) {
      await connection.invoke(
        "CheckAcceptedRequest",
        args: [driver, "0"],
      );
    }
  }

  var activityState = false.obs;

  void openDriver(LatLng location) async {
    debugPrint('SignalR: (Sending) Open Driver');

    String driverId = TokenManager.instance.user?.driverId ?? '';
    var data = {
      'Id': driverId,
      'Latitude': location.latitude,
      'Longitude': location.longitude,
    };

    await connection.invoke(
      "OpenDriver",
      args: [jsonEncode(data)],
    );

    debugPrint('SignalR: (Received) Open Driver');
  }

  Timer? locationSendingTimer;

  void streamDriverLocation() async {
    locationSendingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _updateDriverLocation(),
    );
  }

  void stopStreamDriverLocation() async {
    locationSendingTimer?.cancel();
  }

  void _updateDriverLocation() async {
    LatLng? location = await HyperMapController.instance.getCurrentLocation();
    openDriver(location ?? LatLng(0, 0));
  }

  void closeDriver() async {
    debugPrint('SignalR: (Sending) Close Driver');

    String driverId = TokenManager.instance.user?.driverId ?? '';

    await connection.invoke(
      "CloseDriver",
      args: [driverId],
    );

    debugPrint('SignalR: (Received) Close Driver');
  }

  void driverArrived() async {
    debugPrint('SignalR: (Sending) Driver Arrived');

    String driverId = TokenManager.instance.user?.driverId ?? '';

    await connection.invoke(
      "DriverArrived",
      args: [driverId],
    );

    Get.find<PickUpController>().changeState(PickUpState.picked);

    debugPrint('SignalR: (Received) Driver Arrived');
  }

  void driverPickedUp() async {
    debugPrint('SignalR: (Sending) Driver Picked Up');

    String driverId = TokenManager.instance.user?.driverId ?? '';

    await connection.invoke(
      "DriverPickedUp",
      args: [driverId],
    );

    Get.find<PickUpController>().changeState(PickUpState.finished);

    debugPrint('SignalR: (Received) Driver Picked Up');
  }

  void completedBooking() async {
    debugPrint('SignalR: (Sending) Completed Booking');

    String driverId = TokenManager.instance.user?.driverId ?? '';

    await connection.invoke(
      "CompletedBooking",
      args: [driverId],
    );

    Get.offAllNamed(Routes.MAIN);

    debugPrint('SignalR: (Received) Completed Booking');
  }
}
