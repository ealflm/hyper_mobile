import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/location_model.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRController {
  static final SignalRController _instance = SignalRController._internal();
  static SignalRController get instance => _instance;
  SignalRController._internal();

  HubConnection? _hubConnection;
  late Logger _logger;

  bool connectionIsOpen = false;

  static const host =
      "https://tourism-smart-transportation-api.azurewebsites.net";
  final String _serverUrl = "$host/hub";

  void init() async {
    connectionIsOpen = false;

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint(
          'Hyper SignalR: ${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    _logger = Logger("Hyper SignalR");

    _openConnection();
  }

  void _openConnection() async {
    var token = TokenManager.instance.token;

    final logger = _logger;

    if (_hubConnection == null) {
      final httpConnectionOptions = HttpConnectionOptions(
          logger: logger,
          logMessageContent: true,
          accessTokenFactory: () async {
            return token;
          });

      _hubConnection = HubConnectionBuilder()
          .withUrl(_serverUrl, options: httpConnectionOptions)
          .withAutomaticReconnect(retryDelays: [
            1000,
            2000,
            3000,
            3000,
            3000,
            3000,
            3000,
            3000,
            10000
          ])
          .configureLogging(logger)
          .build();

      _hubConnection?.onclose(({error}) => connectionIsOpen = false);
      _hubConnection?.onreconnecting(({error}) {
        debugPrint("Hyper SignalR: Onreconnecting called");
        connectionIsOpen = false;
      });
      _hubConnection?.onreconnected(({connectionId}) {
        debugPrint("Hyper SignalR: onreconnected called");
        connectionIsOpen = true;
      });
    }

    if (_hubConnection?.state != HubConnectionState.Connected) {
      try {
        await _hubConnection?.start();
        connectionIsOpen = true;
      } catch (e) {
        debugPrint('Hyper SignalR: Connecting again');
        _hubConnection?.stop();
        await _hubConnection?.start();
      }
    }

    _listen();
  }

  Future<void> checkConnection() async {
    if (_hubConnection?.state != HubConnectionState.Connected) {
      debugPrint('Hyper SignalR: Connecting again');
      _hubConnection?.stop();
      await _hubConnection?.start();
    }
  }

  void closeConnection() {
    _hubConnection?.stop();
  }

  void _listen() {
    _hubConnection?.on("BookingResponse", _bookingResponse);
    _hubConnection?.on("DriverArrived", _driverArrived);
    _hubConnection?.on("DriverPickedUp", _driverPickedUp);
    _hubConnection?.on("CompletedBooking", _completedBooking);
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

    String? str = await _hubConnection?.invoke(
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
    checkConnection();
    var data = jsonEncode(locationModel.toJson());
    _hubConnection?.invoke("FindDriver", args: [data, 'true']);
    debugPrint('Hyper SignalR: Finding Driver - $data');
  }

  Future<void> cancelBooking() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    _hubConnection?.invoke(
      "CancelBooking",
      args: [customerId],
    );
  }
}
