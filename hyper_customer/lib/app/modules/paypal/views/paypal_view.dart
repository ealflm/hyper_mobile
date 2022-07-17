import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/paypal_controller.dart';

class PaypalView extends GetView<PaypalController> {
  const PaypalView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: controller.initialUrl,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://example.com/hyper/return')) {
                controller.paymentReturn();
                return NavigationDecision.prevent;
              }
              if (request.url.startsWith('https://example.com/hyper/cancel')) {
                controller.paymentCancel();
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            // onPageStarted: (url) {
            //   debugPrint('onPageStarted: $url');
            // },
          ),
        ),
      ),
    );
  }
}
