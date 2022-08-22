import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:slider_button/slider_button.dart';

class Picked extends GetView<PickUpController> {
  const Picked({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      child: Container(
        decoration: BoxDecorations.map(),
        child: Column(
          children: [
            _user(),
            const Divider(
              height: 1,
            ),
            _location(),
            _button(
              'Đã đón khách',
              SignalR.instance.driverPickedUp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _user() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 15.w),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 34.w,
                width: 34.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary400,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.two_wheeler,
                  color: AppColors.white,
                  size: 16.w,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đặt bởi',
                      style: body2.copyWith(
                        color: AppColors.lightBlack,
                      ),
                    ),
                    Text(
                      'Baroibeo',
                      style: subtitle1.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.softBlack,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.sms_outlined,
                color: AppColors.softBlack,
                size: 28.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _location() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34.w,
            width: 34.w,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.waving_hand,
              color: AppColors.white,
              size: 13.w,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '117 Nguyễn Đình Chiểu',
                  style: subtitle1.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  '117 Nguyễn Đình Chiểu, Phường 6, Quận 3, Hồ Chí Minh',
                  style: body2.copyWith(
                    color: AppColors.lightBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String title, Function() onPressed) {
    return Container(
      padding:
          EdgeInsets.only(left: 15.w, right: 15.w, bottom: 20.h, top: 10.h),
      width: double.infinity,
      child: SliderButton(
        action: onPressed,
        alignLabel: Alignment.center,
        label: Text(
          title,
          style: buttonBold.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.hardBlue,
        height: 56.h,
        buttonSize: 50.h,
        shimmer: false,
        icon: Icon(
          Icons.arrow_forward_ios,
          size: 18.w,
          color: AppColors.gray,
        ),
        boxShadow: BoxShadow(
          offset: const Offset(0, 3),
          blurRadius: 10,
          spreadRadius: 0,
          color: AppColors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}
