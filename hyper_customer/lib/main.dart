import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_customer/app/core/controllers/network_controller.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/config/map_config.dart';
import 'package:intl/intl.dart';

import 'app/my_app.dart';
import 'config/build_config.dart';
import 'config/env_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig envConfig = EnvConfig(
    baseUrl:
        'https://tourism-smart-transportation-api.azurewebsites.net/api/v1.0/customer',
  );

  MapConfig mapConfig = MapConfig(
    mapboxUrlTemplate:
        'https://api.mapbox.com/styles/v1/ealflm/cl5wfx1ln002314qoeuzqjxf3/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZWFsZmxtIiwiYSI6ImNsNXdmM2p6bTBqNTMzbGxjNWczMWZpZmsifQ.fJmdVnQI10s2hMWTm0BpUw',
    mapboxNavigationUrlTemplate:
        'https://api.mapbox.com/styles/v1/ealflm/cl605sc7x001r15pj1wx9b4hf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZWFsZmxtIiwiYSI6ImNsNXdmM2p6bTBqNTMzbGxjNWczMWZpZmsifQ.fJmdVnQI10s2hMWTm0BpUw',
    mapboxAccessToken:
        'pk.eyJ1IjoiZWFsZmxtIiwiYSI6ImNsNXdmM2p6bTBqNTMzbGxjNWczMWZpZmsifQ.fJmdVnQI10s2hMWTm0BpUw',
    mapboxId: 'mapbox.mapbox-streets-v8',
    goongAPIKey: '1kGjGDPqfwSdbfn0t7AwU6glFoSxwJo2Pm5dFmA2',
  );

  BuildConfig(
    envConfig: envConfig,
    mapConfig: mapConfig,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  NetworkController.intance.init();
  TokenManager.instance.init();

  Intl.defaultLocale = 'vi_VN';

  runApp(const MyApp());
}
