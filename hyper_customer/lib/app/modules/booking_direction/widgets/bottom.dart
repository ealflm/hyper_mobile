import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/vehicle.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/service_item.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Bottom extends GetWidget<BookingDirectionController> {
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
              switch (controller.bookingState.value) {
                case BookingState.select:
                  return _select();
                case BookingState.finding:
                  return _findDriver();
                case BookingState.failed:
                  return _failed();
                case BookingState.coming:
                  return Container();
                case BookingState.pickedUp:
                  return Container();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _failed() {
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
              children: [
                Lottie.asset(AppAnimationAssets.cantMatching, width: 150.w),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Rất tiếc, các tài xế gần đây đang bận',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  'Dịch vụ',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.motorcycle,
                    title: 'Xe máy',
                    description: 'Tối đa 1 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.motorcycle,
                    price: controller.motocyclePrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      controller.changeVehicle(Vehicle.motorcycle);
                    },
                  ),
                ),
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.car,
                    title: 'Xe ô tô',
                    description: 'Tối đa 4 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.car,
                    price: controller.carPrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      controller.changeVehicle(Vehicle.car);
                    },
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyles.primaryMedium(),
                    onPressed: () {
                      controller.changeState(BookingState.finding);
                    },
                    child: Text(
                      'Tiếp tục tìm xe',
                      style: buttonBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _select() {
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
                  'Dịch vụ',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.motorcycle,
                    title: 'Xe máy',
                    description: 'Tối đa 1 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.motorcycle,
                    price: controller.motocyclePrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      controller.changeVehicle(Vehicle.motorcycle);
                    },
                  ),
                ),
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.car,
                    title: 'Xe ô tô',
                    description: 'Tối đa 4 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.car,
                    price: controller.carPrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      controller.changeVehicle(Vehicle.car);
                    },
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyles.primaryMedium(),
                    onPressed: () {
                      controller.changeState(BookingState.finding);
                    },
                    child: Text(
                      'Đặt xe',
                      style: buttonBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _findDriver() {
    return SlidingUpPanel(
      color: Colors.transparent,
      boxShadow: const [],
      maxHeight: 480.h,
      minHeight: 215.h,
      panelBuilder: (sc) {
        return SingleChildScrollView(
          controller: sc,
          child: Column(
            children: [
              _goToCurrentLocation(),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.map(),
                  padding: EdgeInsets.only(
                    bottom: 20.h,
                    left: 18.w,
                    right: 18.w,
                    top: 10.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.otp,
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        width: 35.w,
                        height: 4,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Lottie.asset(AppAnimationAssets.lookingDriver,
                          width: 100.w),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Đang tìm tài xế...',
                        style: subtitle1.copyWith(
                          color: AppColors.softBlack,
                          fontSize: 18.sp,
                          fontWeight: FontWeights.medium,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.map(),
                  padding: EdgeInsets.only(
                    bottom: 10.h,
                    left: 18.w,
                    right: 18.w,
                    top: 20.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _start(
                                  title:
                                      '117 Nguyễn Đình Chiểu 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh ',
                                  content:
                                      '117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh',
                                ),
                                _space(),
                                _end(
                                  title:
                                      '117 Nguyễn Đình Chiểu 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh',
                                  content:
                                      '117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh 117 Nguyễn Đình Chiểu, Quận 3, TP Hồ Chí Minh',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Huỷ chuyến xe',
                          style: subtitle2.copyWith(
                            color: AppColors.softRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              controller.mapController.moveToCurrentLocation();
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
