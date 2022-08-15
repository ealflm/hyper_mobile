import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/core/widgets/unfocus.dart';
import 'package:hyper_driver/app/modules/register/controllers/register_controller.dart';
import 'package:hyper_driver/app/modules/register/model/view_state.dart';
import 'package:hyper_driver/app/modules/register/widgets/confirm_address.dart';
import 'package:hyper_driver/app/modules/register/widgets/confirm_info.dart';
import 'package:hyper_driver/app/modules/register/widgets/create_pin.dart';
import 'package:hyper_driver/app/modules/register/widgets/scan.dart';
import 'package:hyper_driver/app/modules/register/widgets/scan_prepare.dart';
import 'package:hyper_driver/app/modules/register/widgets/term_and_condition.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          if (controller.state.value == ViewState.normal)
            _main()
          else if (controller.state.value == ViewState.scanSuccess)
            _scanSuccess()
          else if (controller.state.value == ViewState.registerSuccess)
            _registerSuccess()
        ],
      ),
    );
  }

  Widget _registerSuccess() {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.success,
                            width: 117.r,
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            'Tạo tài khoản thành công',
                            textAlign: TextAlign.center,
                            style: h5.copyWith(
                              color: AppColors.lightBlack,
                              fontWeight: FontWeights.light,
                            ),
                          ),
                          Text(
                            'Cảm ơn bạn đã đăng kí tài khoản Hyper',
                            textAlign: TextAlign.center,
                            style: subtitle1.copyWith(
                              color: AppColors.lightBlack,
                              fontWeight: FontWeights.thin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 20.h,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyles.primary(),
                        onPressed: () {
                          Get.toNamed(
                            Routes.LOGIN,
                            arguments: {
                              'phoneNumber': controller.phoneNumber.value,
                              'registerPassword': controller.password,
                            },
                          );
                        },
                        child: Text(
                          'Đăng nhập',
                          style: buttonBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scanSuccess() {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.success,
                    width: 117.r,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Quét CCCD thành công',
                    textAlign: TextAlign.center,
                    style: h5.copyWith(
                      color: AppColors.lightBlack,
                      fontWeight: FontWeights.light,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _main() {
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
                    child: Container(
                      // height: 1.sh - 88.h,
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
                                switch (controller.step.value) {
                                  case 0:
                                    return const TermAndCondition();
                                  case 1:
                                    return const ScanPrepare();
                                  case 2:
                                    return const Scan();
                                  case 3:
                                    return const ConfirmInfo();
                                  case 4:
                                    return const ConfirmAddress();
                                  case 5:
                                    return const CreatePin();
                                  default:
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
