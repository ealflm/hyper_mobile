import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_customer/app/bindings/initial_binding.dart';
import 'package:hyper_customer/app/core/controllers/network_controller.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

import 'app/my_app.dart';
import 'config/build_config.dart';
import 'config/env_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig envConfig = EnvConfig(
    baseUrl:
        "https://tourism-smart-transportation-api.azurewebsites.net/api/v1.0/customer",
  );

  BuildConfig(
    envConfig: envConfig,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
  ));

  NetworkController.intance.init();
  TokenManager.instance.init();

  runApp(const MyApp());
}
