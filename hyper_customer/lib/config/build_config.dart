import 'package:hyper_customer/config/map_config.dart';

import 'env_config.dart';

class BuildConfig {
  late final EnvConfig config;
  late final MapConfig mapConfig;

  static final BuildConfig _instance = BuildConfig._internal();
  BuildConfig._internal();

  static BuildConfig get instance => _instance;

  factory BuildConfig({
    required EnvConfig envConfig,
    required MapConfig mapConfig,
  }) {
    _instance.config = envConfig;
    _instance.mapConfig = mapConfig;
    return _instance;
  }
}
