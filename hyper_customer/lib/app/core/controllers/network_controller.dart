import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController {
  static final NetworkController _instance = NetworkController._internal();
  static NetworkController get intance => _instance;
  NetworkController._internal();

  var connectionStatus = 0.obs;

  void init() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  _updateConnectionStatus(ConnectivityResult result) async {
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        break;
      case ConnectivityResult.bluetooth:
        connectionStatus.value = 3;
        break;
      case ConnectivityResult.ethernet:
        connectionStatus.value = 4;
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        break;
    }
  }
}
