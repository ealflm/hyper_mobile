import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_driver/app/core/model/location_model.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
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

  void openDriver() async {
    var locationModel = LocationModel(
      id: 'ff7bb0f5-b404-4f36-a736-20a73a7c7498',
      latitude: 10.207511,
      longitude: 103.988106,
    );

    String data = jsonEncode(locationModel.toJson());

    final result = await _hubConnection.invoke(
      "OpenDriver",
      args: <Object>[data],
    );
  }

  void closeDriver() async {
    final bool result = await _hubConnection.invoke(
      "CloseDriver",
      args: <Object>["ff7bb0f5-b404-4f36-a736-20a73a7c7498"],
    ) as bool;

    debugPrint('Hyper SignalR: $result');
  }
}
