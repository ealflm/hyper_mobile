import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_customer/app/core/controllers/network_controller.dart';
import 'package:hyper_customer/app/core/controllers/notification_controller.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/config/map_config.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'app/my_app.dart';
import 'config/build_config.dart';
import 'config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint('SignalR: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  EnvConfig envConfig = EnvConfig(
    baseUrl:
        'https://tourism-smart-transportation-api.azurewebsites.net/api/v1.0/customer',
  );

  MapConfig mapConfig = MapConfig(
    mapboxUrlTemplate:
        'https://api.mapbox.com/styles/v1/namdpse140834/cl6a3eox5001814n736w7m7nz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmFtZHBzZTE0MDgzNCIsImEiOiJjbDZhM2MzOW4xOWFuM2tud3Ezd3dzejk5In0.HVgi6OB6u0WBPlg-F-shag',
    mapboxNavigationUrlTemplate:
        'https://api.mapbox.com/styles/v1/namdpse140834/cl6a3fgk5001815q5izysi14d/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmFtZHBzZTE0MDgzNCIsImEiOiJjbDZhM2MzOW4xOWFuM2tud3Ezd3dzejk5In0.HVgi6OB6u0WBPlg-F-shag',
    mapboxAccessToken:
        'pk.eyJ1IjoibmFtZHBzZTE0MDgzNCIsImEiOiJjbDZhM2MzOW4xOWFuM2tud3Ezd3dzejk5In0.HVgi6OB6u0WBPlg-F-shag',
    mapboxId: 'mapbox.mapbox-streets-v8',
    goongAPIKey: '6maYfn8RLhO7vr3ok3XwDwmYzLHleffe8XsPo1VN',
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

  await TokenManager.instance.init();

  NotificationController.instance.init();

  Intl.defaultLocale = 'vi_VN';
  initializeDateFormatting();

  runApp(const MyApp());
}
