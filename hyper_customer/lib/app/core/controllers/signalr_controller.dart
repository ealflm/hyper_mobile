import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/location_model.dart';
import 'package:hyper_customer/app/modules/booking_direction/bindings/booking_direction_binding.dart';
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

  static late HubConnection _hubConnection;

  static const host =
      "https://tourism-smart-transportation-api.azurewebsites.net/hub";

  void init() async {
    // Logger init
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint(
          'Hyper SignalR: ${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    // If you want only to log out the message for the higer level hub protocol:
    final hubProtLogger = Logger("SignalR - hub");
    // If you want to also to log out transport messages:
    final transportProtLogger = Logger("SignalR - transport");

    var token = TokenManager.instance.token;

    // The location of the SignalR Server.
    final httpOptions = HttpConnectionOptions(
      logger: transportProtLogger,
      accessTokenFactory: () async {
        return token;
      },
    );

    // Creates the connection by using the HubConnectionBuilder.
    _hubConnection = HubConnectionBuilder()
        .withUrl(host, options: httpOptions)
        .configureLogging(hubProtLogger)
        .build();

    // When the connection is closed, print out a message to the console.
    _hubConnection
        .onclose(({error}) => debugPrint("SignalR: connection closed"));

    await _hubConnection.start();

    _hubConnection.on("BookingResponse", _bookingResponse);
    _hubConnection.on("DriverArrived", _driverArrived);
    _hubConnection.on("DriverPickedUp", _driverPickedUp);
    _hubConnection.on("CompletedBooking", _completedBooking);
  }

  void close() {
    _hubConnection.stop();
  }

  void _driverArrived(List<Object>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    bookingDirectionController.changeState(BookingState.coming);
  }

  void _bookingResponse(List<Object>? parameters) {
    debugPrint('_bookingResponse ${parameters?[0]}');
    BookingDirectionController bookingDirectionController =
        Get.find<BookingDirectionController>();

    var map = parameters?[0] as Map<String, dynamic>;
    if (map['statusCode'] == 200) {
      bookingDirectionController.changeState(BookingState.arrived);
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

    String? str = await _hubConnection.invoke(
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
    await _hubConnection.invoke("FindDriver", args: [data]);
  }
}
