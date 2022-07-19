import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/paypal_controller.dart';

class PaypalView extends GetView<PaypalController> {
  const PaypalView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                onProgress: (int progress) {
                  if (progress == 100) {
                    controller.stopLoading();
                  }
                },
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: controller.initialUrl,
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://example.com/hyper')) {
                    controller.paymentReturn();
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
              Obx(
                () => Container(
                  child: controller.firstLoad.value
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.white,
                          child: Center(
                            child: Lottie.asset(
                              AppAnimationAssets.cuteDancingChicken,
                              width: 200.w,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
