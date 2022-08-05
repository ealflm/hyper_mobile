import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/register/controllers/register_controller.dart';
import 'package:hyper_customer/app/modules/register/widgets/scan.dart';
import 'package:hyper_customer/app/modules/register/widgets/scan_prepare.dart';
import 'package:hyper_customer/app/modules/register/widgets/term_and_condition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
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
                  SizedBox(
                    height: 88.h,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: ButtonStyles.textCircle(),
                                  onPressed: () {
                                    controller.back();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text('Đăng ký',
                                style: h6.copyWith(color: AppColors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 712,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecorations.top(),
                      padding:
                          EdgeInsets.only(left: 30.w, top: 30.h, right: 30.w),
                      child: Column(
                        children: [
                          Obx(
                            () => LinearPercentIndicator(
                              padding: EdgeInsets.all(0.r),
                              lineHeight: 5.h,
                              percent: (controller.step.value + 1) / 6,
                              barRadius: Radius.circular(50.r),
                              progressColor: AppColors.primary400,
                              backgroundColor: AppColors.otp,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Expanded(
                            child: Obx(
                              () {
                                if (controller.step.value == 0) {
                                  return const TermAndCondition();
                                } else if (controller.step.value == 1) {
                                  return const ScanPrepare();
                                } else if (controller.step.value == 2) {
                                  return const Scan();
                                } else if (controller.step.value == 3) {
                                  return Container();
                                } else if (controller.step.value == 4) {
                                  return Container();
                                } else if (controller.step.value == 5) {
                                  return Container();
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
