import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_customer/app/core/controllers/location_model.dart';
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
  }

  void close() {
    _hubConnection.stop();
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
