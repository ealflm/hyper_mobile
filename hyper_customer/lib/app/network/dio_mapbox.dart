import 'package:dio/dio.dart';
import 'package:hyper_customer/config/build_config.dart';

class DioMapBox extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['access_token'] =
        BuildConfig.instance.config.mapAccessToken;
    super.onRequest(options, handler);
  }
}
