import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_animation_assets.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/core/widgets/unfocus.dart';
import 'package:hyper_driver/app/modules/scan/models/scan_mode.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

class DestinationArrivedView extends StatelessWidget {
  const DestinationArrivedView({Key? key}) : super(key: key);
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
                            child: Text('Thông tin vị trí',
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
                          _successful(),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Get.offAllNamed(Routes.MAIN);
                                  },
                                  style: ButtonStyles.secondary(),
                                  child: Text(
                                    'Màn hình chính',
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
                                    Get.toNamed(
                                      Routes.SCAN,
                                      arguments: {
                                        'scanMode': ScanMode.renting,
                                      },
                                    );
                                  },
                                  style: ButtonStyles.primary(),
                                  child: Text(
                                    'Quét QR Code',
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

  Column _successful() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.rentingArrived,
              height: 200.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Bạn đã đến trạm thuê xe Hyper',
              style: h6.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Vui lòng quét QR Code để thuê xe',
              style: subtitle1.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
