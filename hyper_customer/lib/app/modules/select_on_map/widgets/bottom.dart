import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/select_on_map/controllers/select_on_map_controller.dart';
import 'package:lottie/lottie.dart';

class Bottom extends GetWidget<SelectOnMapController> {
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
          _detail(),
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
            child: Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isWaiting.value)
                      SizedBox(
                        height: 40.h,
                        child: Center(
                          child: Lottie.asset(
                            AppAnimationAssets.dot,
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.placeDetail.value.placeId != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.placeDetail.value.name}',
                                  style: subtitle1.copyWith(
                                    fontSize: 18.sp,
                                    color: AppColors.softBlack,
                                  ),
                                ),
                                Text(
                                  '${controller.placeDetail.value.formattedAddress}',
                                  style: body2.copyWith(
                                    color: AppColors.description,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
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
                                    controller.fetchPlaceDetail();
                                  },
                                  child: Text(
                                    'Xác nhận',
                                    style: buttonBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              },
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
