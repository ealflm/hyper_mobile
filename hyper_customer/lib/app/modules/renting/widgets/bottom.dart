import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';
import 'package:hyper_customer/app/modules/renting/controllers/zoom_button_controller.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';

class Bottom extends GetWidget<RentingController> {
  const Bottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () {
              switch (controller.rentingState.value) {
                case RentingState.normal:
                  return Container();
                case RentingState.select:
                  return _detail();
                case RentingState.route:
                  return _routeDetail();
                case RentingState.navigation:
                  return _navigation();
                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Container _navigation() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(
            () {
              return controller.isFlowingMode.value
                  ? Column(
                      children: [
                        SizedBox(
                          height: 36.h,
                          width: 124.w,
                          child: ElevatedButton(
                            style: ButtonStyles.primarySmall(),
                            onPressed: () {
                              controller.goToCurrentLeg();
                            },
                            child: HyperButton.child(
                              status: false,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.navigation_outlined,
                                    size: 20.r,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    'Về giữa',
                                    style: buttonBold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    controller.goBackFromNavigation();
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.gray,
                      width: 1.w,
                    ),
                    primary: AppColors.blue,
                    shape: const CircleBorder(),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    minimumSize: Size(50.r, 50.r),
                  ),
                  child: SizedBox(
                    height: 50.r,
                    width: 50.r,
                    child: Icon(
                      Icons.close,
                      size: 24.r,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${controller.legs?.duration?.text}',
                      style: h5.copyWith(
                        color: AppColors.primary400,
                      ),
                    ),
                    Text(
                      '${controller.legs?.distance?.text} • ${DateTimeUtils.currentTimeAdd(second: controller.legs?.duration?.value)}',
                      style: body1.copyWith(
                        color: AppColors.description,
                      ),
                    ),
                  ],
                ),
                GetBuilder<ZoomButtonController>(
                  builder: (controller) {
                    return TextButton(
                      onPressed: () {
                        controller.click();
                      },
                      style: TextButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.gray,
                          width: 1.w,
                        ),
                        primary: AppColors.blue,
                        shape: const CircleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(0),
                        minimumSize: Size(50.r, 50.r),
                      ),
                      child: SizedBox(
                        height: 50.r,
                        width: 50.r,
                        child: Icon(
                          controller.state.value == ZoomButtonState.zoomIn
                              ? Icons.open_in_full
                              : Icons.close_fullscreen,
                          size: 20.r,
                          color: AppColors.gray,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail() {
    return Column(
      children: [
        _goToCurrentLocation(),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          child: Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedStation?.title ?? '',
                  style: subtitle1.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  controller.selectedStation?.address ?? '',
                  style: body2.copyWith(
                    color: AppColors.description,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => SizedBox(
                        height: 36.h,
                        width: 124.w,
                        child: ElevatedButton(
                          style: ButtonStyles.primarySmall(),
                          onPressed: controller.isFindingRoute.value
                              ? null
                              : () {
                                  controller.fetchGoongRoute();
                                },
                          child: HyperButton.child(
                            status: controller.isFindingRoute.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_outlined,
                                  size: 20.r,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  'Đường đi',
                                  style: buttonBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _routeDetail() {
    return Column(
      children: [
        _goToCurrentLocation(),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          child: Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedStation?.title ?? '',
                  style: subtitle1.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  controller.selectedStation?.address ?? '',
                  style: body2.copyWith(
                    color: AppColors.description,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 36.h,
                      width: 124.w,
                      child: ElevatedButton(
                        style: ButtonStyles.primarySmall(),
                        onPressed: () {
                          controller.goToNavigation();
                        },
                        child: HyperButton.child(
                          status: false,
                          child: Row(
                            children: [
                              Icon(
                                Icons.navigation_outlined,
                                size: 20.r,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Bắt đầu',
                                style: buttonBold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _goToCurrentLocation() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.goToCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: AppColors.white,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(0),
              minimumSize: Size(40.r, 40.r),
            ),
            child: SizedBox(
              height: 40.r,
              width: 40.r,
              child: Icon(
                Icons.gps_fixed,
                size: 18.r,
                color: AppColors.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
