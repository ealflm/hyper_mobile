import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/bus_payment/controllers/bus_payment_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

import '../models/state.dart';

class BusPaymentView extends GetView<BusPaymentController> {
  const BusPaymentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.light,
      child: Unfocus(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 400.h,
                color: AppColors.primary400,
              ),
              Column(
                children: [
                  Expanded(
                    flex: 20,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(
                            child: Text('Thanh toán vé xe buýt',
                                style: h6.copyWith(color: AppColors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 80,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecorations.top(),
                      padding: EdgeInsets.only(
                          left: 30.w, top: 20.h, right: 30.w, bottom: 20.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () {
                              return Column(
                                children: [
                                  if (controller.state.value ==
                                      ViewState.loading)
                                    _loading()
                                  else if (controller.state.value ==
                                      ViewState.success)
                                    _successful()
                                  else
                                    _failed(),
                                ],
                              );
                            },
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Get.offAllNamed(Routes.SCAN);
                                  },
                                  style: ButtonStyles.secondary(),
                                  child: Text(
                                    'Tiếp tục quét QR',
                                    style: buttonBold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed(Routes.MAIN);
                                  },
                                  style: ButtonStyles.primary(),
                                  child: Text(
                                    'Màn hình chính',
                                    style: buttonBold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Lottie.asset(
      AppAnimationAssets.earthLoading,
      width: 190.w,
    );
  }

  Column _failed() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.error404,
              width: 200.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Thanh toán thất bại',
              style: h6.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            Text(
              'Đã có lỗi xảy ra trong quá trình xử lí',
              style: subtitle1.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _successful() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.successful,
              repeat: false,
              width: 190.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Thanh toán thành công',
              style: h6.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
