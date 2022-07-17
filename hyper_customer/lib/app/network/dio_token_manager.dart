import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager extends Interceptor {
  static final TokenManager _instance = TokenManager._internal();
  static TokenManager get instance => _instance;
  TokenManager._internal();

  String? _token;

  bool get hasToken => () {
        return _token != null && _token.toString().isNotEmpty ? true : false;
      }();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var response = err.response;
    if (response?.statusCode == 401) {
      clearToken();
      Get.offAllNamed(Routes.START);
    }
    super.onError(err, handler);
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> saveToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();
    if (_token != token && token != null) {
      _token = token;
      await prefs.setString('token', token);
    }
  }

  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    _token = null;
    await prefs.remove('token');
  }
}
