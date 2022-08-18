import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/notification_controller.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/data/models/user_model.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager extends Interceptor {
  static final TokenManager _instance = TokenManager._internal();
  static TokenManager get instance => _instance;
  TokenManager._internal();

  String? _token;
  User? _user;

  User? get user => _user;
  bool get hasToken {
    checkTokenValid();
    return _token != null && _token.toString().isNotEmpty;
  }

  bool get hasUser {
    return _user != null ? true : false;
  }

  String get token {
    checkTokenValid();
    return _token ?? '';
  }

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
      NotificationController.instance.unregisterNotification();
      Get.offAllNamed(Routes.LOGIN);
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

  Future<void> savePhonePassword(
    String? phone,
    String? password, {
    bool? mode,
  }) async {
    var storage = const FlutterSecureStorage();

    await storage.write(
      key: 'phone',
      value: phone,
    );
    await storage.write(
      key: 'password',
      value: password,
    );

    if (mode != null) {
      await storage.write(
        key: 'mode',
        value: mode ? 'true' : 'false',
      );
    }
  }

  void clearPhonePassword() {
    var storage = const FlutterSecureStorage();
    storage.delete(key: 'phone');
    storage.delete(key: 'password');
    storage.delete(key: 'mode');
  }

  Future<String?> getPhone() async {
    var storage = const FlutterSecureStorage();

    return await storage.read(
      key: 'phone',
    );
  }

  Future<String?> getPassword() async {
    var storage = const FlutterSecureStorage();

    return await storage.read(
      key: 'password',
    );
  }

  Future<void> setMode(bool mode) async {
    var storage = const FlutterSecureStorage();

    await storage.write(
      key: 'mode',
      value: mode ? 'true' : 'false',
    );
  }

  Future<bool> getMode() async {
    var storage = const FlutterSecureStorage();

    var mode = await storage.read(
      key: 'mode',
    );

    if (mode == 'true') {
      return true;
    } else {
      return false;
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

  void checkTokenValid() {
    if (_token == null) return;
    Map<String, dynamic> payload = Jwt.parseJwt(_token.toString());

    DateTime? exp = DateTimeUtils.parseDateTime(payload['exp']);

    if (exp != null && exp.compareTo(DateTime.now()) > 0) {
      return;
    } else {
      _token = null;
    }
  }
}
