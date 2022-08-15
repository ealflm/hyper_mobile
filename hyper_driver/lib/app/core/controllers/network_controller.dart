import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class NetworkController {
  static final NetworkController _instance = NetworkController._internal();
  static NetworkController get intance => _instance;
  NetworkController._internal();

  var connectionStatus = 0.obs;
  var _flag = false;

  void init() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  _updateConnectionStatus(ConnectivityResult result) async {
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        _showConnect();
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        _showConnect();
        break;
      case ConnectivityResult.bluetooth:
        _showDisconnect();
        connectionStatus.value = 3;
        break;
      case ConnectivityResult.ethernet:
        connectionStatus.value = 4;
        _showConnect();
        break;
      case ConnectivityResult.none:
        _showDisconnect();
        connectionStatus.value = 0;
        break;
    }
  }

  void _showDisconnect() {
    Get.rawSnackbar(
      backgroundColor: AppColors.snackbar,
      icon: Padding(
        padding: EdgeInsets.only(left: 18.w),
        child: const Icon(
          Icons.wifi_off,
          color: AppColors.white,
        ),
      ),
      borderRadius: 9.r,
      messageText: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(
          'Đã mất kết nối',
          style: body2.copyWith(color: AppColors.white),
        ),
      ),
      margin: EdgeInsets.only(left: 10.w, bottom: 10.h, right: 10.w),
      padding: EdgeInsets.only(
        left: 0.w,
        top: 17.h,
        right: 18.w,
        bottom: 17.h,
      ),
      duration: const Duration(seconds: 5),
    );
  }

  void _showConnect() {
    if (!_flag) {
      _flag = true;
      return;
    }
    Get.rawSnackbar(
      backgroundColor: AppColors.snackbar,
      icon: Padding(
        padding: EdgeInsets.only(left: 18.w),
        child: const Icon(
          Icons.wifi,
          color: AppColors.primary400,
        ),
      ),
      borderRadius: 9.r,
      messageText: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(
          'Đã khôi phục kết nối internet',
          style: body2.copyWith(color: AppColors.white),
        ),
      ),
      margin: EdgeInsets.only(left: 10.w, bottom: 10.h, right: 10.w),
      padding: EdgeInsets.only(
        left: 0.w,
        top: 17.h,
        right: 18.w,
        bottom: 17.h,
      ),
      duration: const Duration(seconds: 5),
    );
  }
}
