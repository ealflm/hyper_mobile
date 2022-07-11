import 'env_config.dart';

class BuildConfig {
  late final EnvConfig config;

  static final BuildConfig _instance = BuildConfig._internal();
  BuildConfig._internal();

  static BuildConfig get instance => _instance;

  factory BuildConfig({
    required EnvConfig envConfig,
  }) {
    _instance.config = envConfig;
    return _instance;
  }
}
