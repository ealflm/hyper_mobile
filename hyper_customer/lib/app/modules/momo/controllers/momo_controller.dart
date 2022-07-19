import 'dart:io';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoController extends BaseController {
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
