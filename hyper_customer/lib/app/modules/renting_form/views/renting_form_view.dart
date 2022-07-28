import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/renting_form/controllers/renting_form_controller.dart';
import 'package:hyper_customer/app/modules/renting_form/models/view_state.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RentingFormView extends GetView<RentingFormController> {
  const RentingFormView({Key? key}) : super(key: key);
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
                            child: Text('Thuê xe',
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
                          GetBuilder<RentingFormController>(
                            builder: (_) {
                              return Column(
                                children: [
                                  if (controller.state == ViewState.loading)
                                    _loading()
                                  else if (controller.state ==
                                      ViewState.successful)
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed(Routes.MAIN);
                                  },
                                  style: ButtonStyles.primary(),
                                  child: Text(
                                    'Tiếp tục',
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
              'Kết nối thất bại',
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
    List<Widget> tabs = [
      Column(
        children: [
          // Lottie.asset(
          //   AppAnimationAssets.successful,
          //   repeat: false,
          //   height: 138.h,
          // ),
          Text(
            '${controller.vehicleRental?.vehicleName}',
            style: h5.copyWith(
              fontWeight: FontWeights.medium,
              color: AppColors.softBlack,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '${NumberUtils.vnd(controller.vehicleRental?.pricePerHour?.toDouble())}/giờ',
            style: h6.copyWith(
              fontWeight: FontWeights.regular,
              color: AppColors.softBlack,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '${NumberUtils.vnd(controller.vehicleRental?.pricePerDay?.toDouble())}/ngày',
            style: subtitle1.copyWith(
              fontWeight: FontWeights.regular,
              color: AppColors.lightBlack,
            ),
          ),
        ],
      ),
    ];
    return Column(
      children: [
        Column(
          children: [
            LinearPercentIndicator(
              padding: EdgeInsets.all(0.r),
              animation: true,
              lineHeight: 5.h,
              animationDuration: 0,
              percent: 1 / 3,
              barRadius: Radius.circular(50.r),
              progressColor: AppColors.primary400,
              backgroundColor: AppColors.otp,
            ),
            SizedBox(
              height: 50.h,
            ),
            tabs[controller.tabIndex.value],
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Column(
          children: [
            _detailItem(
              'Biển số',
              '${controller.vehicleRental?.licensePlates}',
            ),
            const Divider(
              color: AppColors.line,
            ),
            _detailItem(
              'Màu sắc',
              '${controller.vehicleRental?.color}',
            ),
            const Divider(
              color: AppColors.line,
            ),
            _detailItem(
              'Năm sản xuất',
              '${controller.vehicleRental?.publishYearName}',
            ),
          ],
        ),
      ],
    );
  }

  Row _detailItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: subtitle2.copyWith(
            fontWeight: FontWeights.regular,
            color: AppColors.lightBlack,
          ),
        ),
        Text(
          value,
          style: subtitle2.copyWith(color: AppColors.softBlack),
        ),
      ],
    );
  }
}
