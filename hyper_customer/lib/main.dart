import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_customer/app/core/controllers/network_controller.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/config/map_config.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/my_app.dart';
import 'config/build_config.dart';
import 'config/env_config.dart';
import 'config/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    goongAPIKey: 'ef2C1213EX9S9cnaI1QS7irE0M0dxSGjEZSENVdA',
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

  initFireBase();

  Intl.defaultLocale = 'vi_VN';
  initializeDateFormatting();

  runApp(const MyApp());
}

void initFireBase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  TokenManager.instance.init();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Notification: Got a message whilst in the foreground!');
    debugPrint('Notification: Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Notification: Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "Notification: Handling a background message: ${message.messageId}");
}
