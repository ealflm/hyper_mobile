import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager extends Interceptor {
  static final TokenManager _instance = TokenManager._internal();
  static TokenManager get instance => _instance;
  TokenManager._internal();

  String? _token;
  User? _user;

  User? get user => _user;
  bool get hasToken => () {
        return _token != null && _token.toString().isNotEmpty ? true : false;
      }();
  bool get hasUser => () {
        return _user != null ? true : false;
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

    String? userJson = prefs.getString('userJson');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson.toString()));
    }
  }

  Future<void> saveToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();

    if (_token != token && token != null) {
      _token = token;
      await prefs.setString('token', token);
    }
  }

  Future<void> saveUser(String? token) async {
    var prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> payload = Jwt.parseJwt(token.toString());
    String userJson = json.encode(payload);

    if (userJson.isNotEmpty) {
      _user = User.fromJson(json.decode(userJson.toString()));
      await prefs.setString('userJson', userJson);
    }
  }

  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    _token = null;
    await prefs.remove('token');
  }

  Future<void> clearUser() async {
    var prefs = await SharedPreferences.getInstance();
    _user = null;
    await prefs.remove('userJson');
  }
}
