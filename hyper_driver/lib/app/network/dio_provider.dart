import 'package:dio/dio.dart';
import 'package:hyper_driver/app/network/dio_debug.dart';
import 'package:hyper_driver/app/network/dio_goong.dart';
import 'package:hyper_driver/app/network/dio_mapbox.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:hyper_driver/config/build_config.dart';

class DioProvider {
  static final String baseUrl = BuildConfig.instance.config.baseUrl;

  static Dio? _instance;

  static final BaseOptions _options = BaseOptions(
    baseUrl: baseUrl,
  );

  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);

      _instance!.interceptors.add(DioDebug()); // For debug

      return _instance!;
    } else {
      _instance!.interceptors.clear(); // For debug
      _instance!.interceptors.add(DioDebug()); // For debug
      return _instance!;
    }
  }

  static Dio get dioWithHeaderToken {
    _addInterceptors();

    return _instance!;
  }

  static Dio get dioWithMapboxToken {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(DioMapBox());
    _instance!.interceptors.add(DioDebug()); // For debug

    return _instance!;
  }

  static Dio get dioWithGoongAPIKey {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(DioGoong());
    _instance!.interceptors.add(DioDebug()); // For debug

    return _instance!;
  }

  static _addInterceptors() {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(TokenManager.instance);
    _instance!.interceptors.add(DioDebug()); // For debug
  }
}
