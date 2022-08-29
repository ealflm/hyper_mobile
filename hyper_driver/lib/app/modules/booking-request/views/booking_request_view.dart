import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_shape.dart';

import '../controllers/booking_request_controller.dart';

class BookingRequestView extends GetView<BookingRequestController> {
  const BookingRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 18.w,
            top: 10.h,
            right: 18.w,
            bottom: 15.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          color: AppColors.primary400,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.two_wheeler,
                          color: AppColors.white,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Nhận cuốc xe',
                        style: h5.copyWith(color: AppColors.softBlack),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  _searchInput(),
                  SizedBox(
                    height: 10.h,
                  ),
                  _distance(),
                ],
              ),
              Row(
                children: [
                  _circleButton(
                    () {
                      Get.back(result: 0);
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: _button(
                      'Chấp nhận',
                      () {
                        Get.back(result: 1);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _distance() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      // decoration: BoxDecoration(
      //   color: AppColors.background,
      //   borderRadius: BorderRadius.circular(9.r),
      //   border: Border.all(color: AppColors.description),
      // ),
      decoration: BoxDecorations.map(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Khoảng cách',
                style: body2.copyWith(color: AppColors.softBlack),
              ),
              Text(
                '3.6 Km',
                style: subtitle2.copyWith(color: AppColors.softBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      // decoration: BoxDecoration(
      //   color: AppColors.background,
      //   borderRadius: BorderRadius.circular(9.r),
      //   border: Border.all(color: AppColors.description),
      // ),
      decoration: BoxDecorations.map(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => SignalR.instance.startPlace.value != null &&
                    SignalR.instance.endLocation.value != null
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _start(
                              title:
                                  SignalR.instance.startPlace.value?.name ?? '',
                              content: SignalR.instance.startPlace.value
                                      ?.formattedAddress ??
                                  '',
                            ),
                            _space(),
                            _end(
                              title:
                                  SignalR.instance.endPlace.value?.name ?? '',
                              content: SignalR.instance.endPlace.value
                                      ?.formattedAddress ??
                                  '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Text('Đã có lỗi xảy ra'),
          ),
        ],
      ),
    );
  }

  Widget _start({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperShape.startCircle(),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle1.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.softBlack,
                ),
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _space() {
    return Container(
      padding: EdgeInsets.only(left: 18.r + 10.w),
      height: 40.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HyperShape.dot(),
          HyperShape.dot(),
          HyperShape.dot(),
        ],
      ),
    );
  }

  Widget _end({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperShape.endCircle(),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle1.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.softBlack,
                ),
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
          Icons.close,
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
}
