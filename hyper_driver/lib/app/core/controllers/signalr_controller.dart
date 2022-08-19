import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_driver/app/core/model/data_hub_model.dart';
import 'package:hyper_driver/app/core/model/driver_response_model.dart';
import 'package:hyper_driver/app/core/model/location_model.dart';
import 'package:hyper_driver/app/core/model/startLocationBooking_model.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRController {
  static final SignalRController _instance = SignalRController._internal();
  static SignalRController get instance => _instance;
  SignalRController._internal();

  static late HubConnection _hubConnection;

  // static const host = "http://10.0.2.2:5000/hub";
  // static const host = "http://localhost:5000/hub";

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

    // Call from sever
    // _hubConnection.on("BookingRequest", _bookingRequest);
    // _hubConnection.on("BookingResponse", _bookingResponse);
  }

  // void _bookingRequest(List<Object>? parameters) async {
  //   debugPrint('_bookingRequest ${parameters?[0]}');

  //   var locationModel = LocationModel(
  //     id: '84cd154d-a453-497a-b2aa-85a5aa9d9029',
  //     latitude: 10.865836,
  //     longitude: 106.781622,
  //   );

  //   String data = jsonEncode(locationModel.toJson());

  //   var mapper = parameters?[0] as Map<String, dynamic>;
  //   var driver = jsonEncode(DataHubModel.fromJson(mapper['driver']).toJson());
  //   var customer =
  //       jsonEncode(DataHubModel.fromJson(mapper['customer']).toJson());

  //   driver = jsonEncode(DriverResponseModel.fromJson(mapper));

  //   final result = await _hubConnection.invoke(
  //     "CheckAcceptedRequest",
  //     args: <Object>[driver, "1"],
  //   );

  //   debugPrint('CheckAcceptedRequest ${parameters?[0]}');
  // }

  // void _bookingResponse(List<Object>? parameters) {
  //   debugPrint('_bookingResponse ${parameters?[0]}');
  // }

  // void closeDriver() async {
  //   // var locationModel = LocationModel(
  //   //   id: '84cd154d-a453-497a-b2aa-85a5aa9d9029',
  //   //   latitude: 10.864483,
  //   //   longitude: 106.780907,
  //   //   seats: 2,
  //   // );

  //   // String data = jsonEncode(locationModel.toJson());

  //   final result = await _hubConnection.invoke(
  //     "CloseDriver",
  //     args: <Object>["84cd154d-a453-497a-b2aa-85a5aa9d9029"],
  //   );

  //   debugPrint('Hyper SignalR: $result');
  // }

  // void action1() async {
  //   var locationModel = StartLocationBookingModel(
  //     id: '1D17684A-00DD-4840-937B-9BC1E4DA033D',
  //     latitude: 10.868463,
  //     longitude: 106.779407,
  //   );
  //   String data = jsonEncode(locationModel.toJson());
  //   final String result = await _hubConnection.invoke(
  //     "GetDriversListMatching",
  //     args: <Object>[data],
  //   ) as String;

  //   debugPrint('Hyper SignalR: Action 1 Pressed $result');
  // }

  // void action2() async {
  //   var locationModel = LocationModel(
  //     id: '1D17684A-00DD-4840-937B-9BC1E4DA033D',
  //     latitude: 10.868463,
  //     longitude: 106.779407,
  //     priceBookingId: '8C06808E-E38A-4A1D-90FF-04E153DDF1FF',
  //     price: 99000,
  //     distance: 2500,
  //     seats: 2,
  //   );

  //   String data = jsonEncode(locationModel.toJson());
  //   final result = await _hubConnection.invoke(
  //     "FindDriver",
  //     args: <Object>[data],
  //   );

  //   debugPrint('Hyper SignalR: Action 2 Pressed');
  // }

  // void action3() async {
  //   debugPrint('Hyper SignalR: Action 3 Pressed');

  //   final result = await _hubConnection.invoke(
  //     "CancelBooking",
  //     args: <Object>['1D17684A-00DD-4840-937B-9BC1E4DA033D'],
  //   );
  //   // TO DO
  // }

  // void action4() async {
  //   debugPrint('Hyper SignalR: Action 4 Pressed');
  //   // TO DO
  // }

  // void action5() async {
  //   debugPrint('Hyper SignalR: Action 5 Pressed');
  //   // TO DO
  // }

  void close() {
    _hubConnection.stop();
  }

  void openDriver(LatLng location) async {
    String driverId = TokenManager.instance.user?.driverId ?? '';
    var data = {
      'Id': driverId,
      'Latitude': location.latitude,
      'Longitude': location.longitude,
    };

    final result = await _hubConnection.invoke(
      "OpenDriver",
      args: [jsonEncode(data)],
    );

    debugPrint(result.toString());
  }

  void closeDriver() async {
    String driverId = TokenManager.instance.user?.driverId ?? '';

    final result = await _hubConnection.invoke(
      "CloseDriver",
      args: [driverId],
    );

    debugPrint(result.toString());
  }
}
