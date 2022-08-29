import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: ButtonStyles.textCircle(),
                                  onPressed: () {
                                    Get.offNamed(Routes.SCAN);
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
                                      ViewState.showInfo)
                                    _showInfo()
                                  else if (controller.state.value ==
                                      ViewState.done)
                                    _done()
                                  else if (controller.state.value ==
                                      ViewState.success)
                                    _successful()
                                  else
                                    _failed(),
                                ],
                              );
                            },
                          ),
                          Obx(
                            () {
                              if (controller.state.value ==
                                  ViewState.showInfo) {
                                return _bottomInfo();
                              } else if (controller.state.value ==
                                      ViewState.success ||
                                  controller.state.value == ViewState.done) {
                                return _bottomSuccess();
                              } else if (controller.state.value ==
                                  ViewState.error) {
                                return _bottomSuccess();
                              } else {
                                return Container();
                              }
                            },
                          ),
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

  Column _bottomSuccess() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => controller.fromBusing.value
                ? ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyles.primary(),
                    child: Text(
                      'Trở lại bản đồ',
                      style: buttonBold,
                    ),
                  )
                : ElevatedButton(
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
        ),
      ],
    );
  }

  Column _bottomInfo() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.busPayment,
            style: ButtonStyles.primary(),
            child: Text(
              'Thanh toán',
              style: buttonBold,
            ),
          ),
        ),
      ],
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

  Widget _showInfo() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Chi tiết chuyến đi',
              style: h6.copyWith(
                color: AppColors.softBlack,
                fontWeight: FontWeights.regular,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        Obx(
          () => controller.busTrip.value != null
              ? Column(
                  children: [
                    _detailItem(
                      'Tên chuyến',
                      controller.busTrip.value?.name ?? '-',
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    _detailItem(
                      'Tổng số trạm',
                      controller.busTrip.value?.totalStation.toString() ?? '-',
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    _detailItem(
                      'Khoảng cách',
                      NumberUtils.distance(
                        controller.busTrip.value?.distance ?? 0,
                      ),
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(
                      () => controller.busTrip.value?.isUsePackage == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Tổng tiền',
                                      style: subtitle1.copyWith(
                                        fontWeight: FontWeights.regular,
                                        color: AppColors.lightBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      NumberUtils.vnd(
                                          controller.busTrip.value?.price),
                                      style: subtitle1.copyWith(
                                        color: AppColors.softBlack,
                                        fontWeight: FontWeights.medium,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Tổng tiền',
                                      style: subtitle1.copyWith(
                                        fontWeight: FontWeights.regular,
                                        color: AppColors.lightBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      NumberUtils.vnd(
                                          controller.busTrip.value?.price),
                                      style: subtitle1.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.gray,
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                    Text(
                                      'Sử dụng gói dịch vụ',
                                      style: subtitle1.copyWith(
                                        color: AppColors.softBlack,
                                      ),
                                    ),
                                    Text(
                                      NumberUtils.vnd(0),
                                      style: subtitle1.copyWith(
                                        color: AppColors.softBlack,
                                        fontWeight: FontWeights.medium,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                )
              : Container(),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              padding: EdgeInsets.all(3.r),
              decoration: const BoxDecoration(
                color: AppColors.primary400,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.lightBulb,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                'Tiền sẽ được hoàn lại nếu bạn không đi hết chuyến',
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _done() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.successful,
              repeat: false,
              height: 138.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Đã hoàn thành chuyến',
              style: h6.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Hyper cảm ơn quý khách đã sử dụng dịch vụ',
              textAlign: TextAlign.center,
              style: subtitle1.copyWith(
                fontWeight: FontWeights.regular,
                color: AppColors.lightBlack,
                fontSize: 18.sp,
              ),
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

  Widget _successful() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.successful,
              repeat: false,
              height: 138.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => controller.busTrip.value?.isUsePackage == false
                  ? Column(
                      children: [
                        Text(
                          'Giao dịch thành công',
                          style: subtitle1.copyWith(
                            fontWeight: FontWeights.medium,
                            color: AppColors.lightBlack,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          NumberUtils.vnd(controller.busTrip.value?.price),
                          style: h5.copyWith(
                            fontWeight: FontWeights.medium,
                            color: AppColors.softBlack,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          'Sử dụng gói dịch vụ thành công',
                          style: subtitle1.copyWith(
                            fontWeight: FontWeights.medium,
                            color: AppColors.lightBlack,
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Obx(
              () => controller.busTrip.value != null
                  ? Column(
                      children: [
                        _detailItem(
                          'Tên chuyến',
                          controller.busTrip.value?.name ?? '-',
                        ),
                        const Divider(
                          color: AppColors.line,
                        ),
                        _detailItem(
                          'Tổng số trạm',
                          controller.busTrip.value?.totalStation.toString() ??
                              '-',
                        ),
                        const Divider(
                          color: AppColors.line,
                        ),
                        _detailItem(
                          'Khoảng cách',
                          NumberUtils.distance(
                            controller.busTrip.value?.distance ?? 0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
