import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioDebug extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('API debug >> make request: ${options.uri}');
    debugPrint('API debug >> make request: ${options.headers}');
    debugPrint('API debug >> make request: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('API debug >> http status code: ${response.statusCode}');
    debugPrint('API debug >> response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var response = err.response;
    debugPrint('API debug >> http status code: ${response?.statusCode}');
    debugPrint('API debug >> response: ${response?.data}');
    super.onError(err, handler);
  }
}
