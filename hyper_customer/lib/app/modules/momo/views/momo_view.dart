import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/model/payment_result.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/momo_controller.dart';

class MomoView extends GetView<MomoController> {
  const MomoView({Key? key}) : super(key: key);
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
                  if (request.url
                      .startsWith('momo://?action=payWithAppToken')) {
                    controller.goToUrl(request.url);
                    return NavigationDecision.prevent;
                  }
                  if (request.url.startsWith('hyper://customer.app')) {
                    Get.toNamed(Routes.PAYMENT_STATUS, arguments: {
                      'paymentResult': PaymentResult(
                        status: false,
                      ),
                    });
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                AppAnimationAssets.cuteDancingChickenCrop,
                                width: 140.w,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'Đang tải...',
                                style: subtitle1.copyWith(
                                    color: AppColors.lightBlack),
                              ),
                            ],
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
