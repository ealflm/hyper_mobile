import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/firebase_options.dart';

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
      unregisterNotification();
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
    registerNotification();
  }

  Future<void> registerNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final String customerId = user?.customerId ?? '';
    debugPrint('Notification: fcmToken: $fcmToken');

    var registerNotificationService = repository.registerNotification(
      customerId,
      fcmToken,
    );

    try {
      await registerNotificationService;
    } catch (error) {
      debugPrint('Notification: Can not register');
      rethrow;
    }
  }

  Future<void> unregisterNotification() async {
    Repository repository = Get.find(tag: (Repository).toString());
    final String customerId = user?.customerId ?? '';

    var registerNotificationService = repository.registerNotification(
      customerId,
      '',
    );

    try {
      await registerNotificationService;
    } catch (error) {
      debugPrint('Notification: Can not unregister');
      rethrow;
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
}
