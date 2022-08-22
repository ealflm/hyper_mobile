import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/model/location_model.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalR {
  static final SignalR _instance = SignalR._internal();
  static SignalR get instance => _instance;
  SignalR._internal();

  // Region Init

  static const host =
      "https://tourism-smart-transportation-api.azurewebsites.net/hub";

  static late HubConnection connection;
  static late Logger _logger;

  List<int> retryDelays = [
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    1000,
    2000,
    2000,
    2000,
    2000,
    2000,
    4000,
    4000,
    4000,
    4000,
    4000,
    4000,
    8000,
    8000,
    8000,
    16000,
    16000,
    16000,
    32000,
    32000,
    32000,
    32000
  ];

  void init() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint('SignalR: ${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    _logger = Logger("SignalR: ");

    startConnection();
  }

  Future<void> startConnection() async {
    debugPrint('SignalR: Starting connection');

    String token = TokenManager.instance.token;

    final httpConnectionOptions = HttpConnectionOptions(
      logging: (level, message) {
        debugPrint('SignalR: $message');
      },
      logMessageContent: true,
      accessTokenFactory: () async {
        return token;
      },
    );

    connection = HubConnectionBuilder()
        .withUrl(host, httpConnectionOptions)
        .withAutomaticReconnect(retryDelays)
        .build();

    connection.onclose(
      (exception) {
        debugPrint('SignalR: On close');
      },
    );

    connection.onreconnecting(((exception) {
      debugPrint('SignalR: On reconnecting!');
    }));

    connection.onreconnected(((String? connectionId) {
      debugPrint('SignalR: Reconnected with connectionId $connectionId');
    }));

    _connectionOn();

    await connection.start();
    debugPrint('SignalR: Connection started: ${connection.connectionId}');
  }

  void close() async {
    await connection.stop();
    debugPrint('SignalR: Connection stopped');
  }

  // End Region

  // Region Connection On

  void _connectionOn() {
    connection.on("PingToCustomer", _pingToCustomer);
    connection.on("BookingResponse", _bookingResponse);
    connection.on("DriverArrived", _driverArrived);
    connection.on("DriverPickedUp", _driverPickedUp);
    connection.on("CompletedBooking", _completedBooking);
  }

  void _pingToCustomer(List<dynamic>? parameters) {
    debugPrint('Received Ping from Sever ${parameters?[0]}');
  }

  Future<void> pingToServer() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    debugPrint('SignalR: Staring ping to sever');

    await connection.invoke(
      "Ping",
      args: [customerId],
    );

    debugPrint('SignalR: Ping success to sever');
  }

  void _driverArrived(List<dynamic>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.arrived);
  }

  void _bookingResponse(List<dynamic>? parameters) {
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

  void _driverPickedUp(List<dynamic>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.pickedUp);
  }

  void _completedBooking(List<dynamic>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.feedBack);
  }

  // End Region

  // Region Invoke

  Future<List<LatLng>> getDriverInfos(LatLng location) async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var data = {
      'Id': customerId,
      'Latitude': location.latitude,
      'Longitude': location.longitude,
    };

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

  // End Region
}
