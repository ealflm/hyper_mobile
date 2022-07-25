import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';
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
          _goToCurrentLocation(),
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
                  return Container();
                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Container _detail() {
    return Container(
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
                              controller.findRoute();
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
    );
  }

  Container _routeDetail() {
    return Container(
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
