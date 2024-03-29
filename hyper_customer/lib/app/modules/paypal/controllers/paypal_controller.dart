import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/model/payment_result.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  String id = '';
  var initialUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=';
  var firstLoad = true.obs;

  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    id = Get.arguments['id'];
    initialUrl += Get.arguments['id'];

    super.onInit();
  }

  @override
  void onReady() {
    if (id.isEmpty) Get.offAllNamed(Routes.HOME);
    super.onReady();
  }

  Future<void> paymentReturn(String url) async {
    Uri uri = Uri.parse(url);
    var depositService = _repository.checkDeposit(id);

    bool result = false;

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

    PaymentResult paymentResult = PaymentResult.fromString(
      status: result ? '0' : '1',
      uid: uri.queryParameters['uid'],
      amount: uri.queryParameters['amount'],
      createdDate: uri.queryParameters['create-date'],
      source: 'paypal',
    );

    Get.offAllNamed(
      Routes.PAYMENT_STATUS,
      arguments: {
        'paymentResult': paymentResult,
      },
    );
  }

  void stopLoading() {
    firstLoad.value = false;
  }
}
