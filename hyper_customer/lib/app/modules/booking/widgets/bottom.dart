import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/modules/booking/controllers/booking_controller.dart';

class Bottom extends GetWidget<BookingController> {
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
        ],
      ),
    );
  }

  Container _goToCurrentLocation() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Obx(
                () {
                  if (controller.startPlace.value.placeId != null &&
                      controller.endPlace.value.placeId != null) {
                    return ElevatedButton(
                      onPressed: () {
                        controller.centerZoomFitBounds();
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
                          Icons.open_in_full,
                          size: 18.r,
                          color: AppColors.gray,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 10.h,
              ),
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
        ],
      ),
    );
  }
}
