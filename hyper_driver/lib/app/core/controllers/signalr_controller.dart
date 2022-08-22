import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/model/driver_response_model.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../routes/app_pages.dart';

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
      debugPrint("SignalR: Onreconnecting called");

      changeState(ConnectionState.disconnected);

      connection.stop();
      _openConnection();
    });
    connection.onreconnected(({connectionId}) {
      debugPrint("SignalR: onreconnected called");

      changeState(ConnectionState.connected);
    });

    if (connection.state != HubConnectionState.Connected) {
      try {
        await connection.start();

        changeState(ConnectionState.connected);

        debugPrint('SignalR: Connected (${connection.connectionId})');
        Utils.showToast('Kết nối tới server thành công');
      } catch (e) {
        if (_autoReconnect) {
          debugPrint('SignalR: Connecting again');

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
    connection.on("BookingRequest", _bookingRequest);
    connection.on("CanceledBooking", _canceledBooking);
    connection.on("FindingOut", _findingOut);
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

    Get.find<PickUpController>().changeState(PickUpState.completed);

    debugPrint('SignalR: (Received) Completed Booking');
  }
}
