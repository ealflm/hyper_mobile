import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  String id = '';
  var initialUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=';

  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    id = Get.arguments['id'];
    initialUrl += id;
    super.onInit();
  }

  @override
  void onReady() {
    if (id.isEmpty) Get.offAllNamed(Routes.HOME);
    super.onReady();
  }

  Future<void> paymentReturn() async {
    var depositService = _repository.checkDeposit(id);

    bool? result;

    await callDataService(
      depositService,
      onSuccess: (bool response) {
        result = response;
      },
      onError: (DioError dioError) {
        if (dioError.response?.statusCode == 400) {
          result = false;
        }
      },
    );

    if (result == null) {
      Utils.showToast('Kết nối thất bại');
    } else if (result == true) {
      Utils.showToast('Thanh toán thành công');
      Get.offAllNamed(Routes.MAIN);
    } else if (result == false) {
      Utils.showToast('Thanh toán thất bại');
      Get.back();
    }
  }

  void paymentCancel() {
    Utils.showToast('Đã huỷ thanh toán');
    Get.back();
  }
}
