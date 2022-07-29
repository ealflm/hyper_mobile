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
import 'package:hyper_customer/app/modules/renting_form/widgets/payment_detail.dart';
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: ButtonStyles.textCircle(),
                                  onPressed: () {
                                    Get.back();
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
                          Obx(
                            () {
                              switch (controller.state.value) {
                                case ViewState.loading:
                                  return _loading();
                                case ViewState.successful:
                                  return _successful();
                                case ViewState.failed:
                                  return _failed();
                                case ViewState.paymentSuccessful:
                                  return _paymentSuccessful();
                                case ViewState.paymentFailed:
                                  return _paymentFailed();
                              }
                            },
                          ),
                          Obx(
                            () => Column(
                              children: [
                                if (controller.getTab() == 0)
                                  _button(
                                    'Tiếp tục',
                                    () {
                                      controller.changeTab(1);
                                    },
                                  )
                                else if (controller.getTab() == 1)
                                  Row(
                                    children: [
                                      _circleButton(
                                        () {
                                          controller.changeTab(0);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: _button(
                                          'Tiếp tục',
                                          () {
                                            controller.changeTab(2);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                else if (controller.getTab() == 2)
                                  Row(
                                    children: [
                                      _circleButton(
                                        () {
                                          controller.changeTab(1);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: _button(
                                          'Thanh toán',
                                          () {
                                            controller.createOrder();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
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

  Widget _paymentSuccessful() {
    return Container(child: Text('Thanh toán thành công'));
  }

  Widget _paymentFailed() {
    return Container(child: Text('Thanh toán thất bại'));
  }

  ElevatedButton _circleButton(Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: AppColors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0),
        minimumSize: Size(50.r, 50.r),
      ),
      child: SizedBox(
        height: 50.r,
        width: 50.r,
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 18.r,
          color: AppColors.lightBlack,
        ),
      ),
    );
  }

  Widget _button(String title, Function()? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyles.primary(),
        child: Text(
          title,
          style: buttonBold,
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
      _first(),
      _second(),
      const PaymentDetail(),
    ];
    return Obx(
      () => Column(
        children: [
          LinearPercentIndicator(
            padding: EdgeInsets.all(0.r),
            animation: true,
            lineHeight: 5.h,
            animationDuration: 0,
            percent: (controller.getTab() + 1) / 3,
            barRadius: Radius.circular(50.r),
            progressColor: AppColors.primary400,
            backgroundColor: AppColors.otp,
          ),
          SizedBox(
            height: 30.h,
          ),
          tabs[controller.getTab()],
        ],
      ),
    );
  }

  Column _second() {
    return Column(
      children: [
        Container(
          height: 32.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: TabBar(
            controller: controller.modeController,
            onTap: (index) {
              controller.changeMode(index);
            },
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: AppColors.primary400,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  color: AppColors.primary500.withOpacity(0.4),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.description,
            tabs: controller.modes,
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Obx(
                () => controller.modesWidget[controller.modeIndex.value],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _first() {
    return Column(
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
          style: subtitle1.copyWith(
            fontWeight: FontWeights.regular,
            color: AppColors.lightBlack,
          ),
        ),
        Text(
          value,
          style: subtitle1.copyWith(
            color: AppColors.softBlack,
            fontWeight: FontWeights.medium,
          ),
        ),
      ],
    );
  }
}
