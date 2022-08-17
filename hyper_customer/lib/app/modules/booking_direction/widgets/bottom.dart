import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/vehicle.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/service_item.dart';

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
                    onPressed: () {},
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
}
