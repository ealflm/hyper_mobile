import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class Top extends GetWidget<HomeController> {
  const Top({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 20.w,
          right: 10.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: AppColors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.BOOKING_REQUEST);
                },
                child: Obx(
                  () => SignalR.instance.activityState.value
                      ? _active()
                      : _disable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _active() {
    return Row(
      children: [
        Text(
          'Sẵn sàng nhận chuyến',
          style: subtitle2.copyWith(color: AppColors.softBlack),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 7.h,
          width: 7.h,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.primary400),
        ),
      ],
    );
  }

  Row _disable() {
    return Row(
      children: [
        Text(
          'Không hoạt động',
          style: subtitle2.copyWith(color: AppColors.description),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          height: 7.h,
          width: 7.h,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.description),
        ),
      ],
    );
  }
}
