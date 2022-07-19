import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  String initialUrl = '';
  var firstLoad = true.obs;

  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    initialUrl = Get.arguments['initialUrl'].toString();

    super.onInit();
  }

  @override
  void onReady() {
    if (initialUrl.isEmpty) Get.offAllNamed(Routes.HOME);
    super.onReady();
  }

  Future<void> paymentReturn() async {
    var depositService = _repository.checkDeposit(initialUrl);

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

    Get.offAllNamed(
      Routes.PAYMENT_STATUS,
      arguments: {'status': result},
    );
  }

  void stopLoading() {
    firstLoad.value = false;
  }

  Future<void> goToUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }
}
