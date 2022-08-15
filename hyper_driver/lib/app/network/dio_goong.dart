import 'package:dio/dio.dart';
import 'package:hyper_driver/config/build_config.dart';

class DioGoong extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['api_key'] =
        BuildConfig.instance.mapConfig.goongAPIKey;
    super.onRequest(options, handler);
  }
}
