import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_button.dart';
import 'package:hyper_driver/app/modules/bus_direction/controllers/bus_direction_controller.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class Bottom extends GetWidget<BusDirectionController> {
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
          _detail(),
        ],
      ),
    );
  }

  Widget _detail() {
    return Obx(
      () => ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppValues.busDirectionMinHeight,
          maxHeight: controller.isExpanded.value
              ? AppValues.busDirectionMaxHeight
              : AppValues.busDirectionMinHeight,
        ),
        child: Container(
          decoration: BoxDecorations.top(),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 9.h,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: controller.toggleExpand,
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(0),
                        minimumSize: Size(40.r, 40.r),
                      ),
                      child: SizedBox(
                        height: 40.r,
                        width: 40.r,
                        child: Icon(
                          controller.isExpanded.value
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: AppColors.gray,
                          size: 26.r,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                      width: 124.w,
                      child: ElevatedButton(
                        style: ButtonStyles.primarySmall(),
                        onPressed: controller.getToScanView,
                        child: HyperButton.child(
                          status: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 20.r,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Quét QR',
                                style: buttonBold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Divider(
                  color: AppColors.line,
                  height: 1.h,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: controller.directions.value,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: Text(
                          'Kết thúc hành trình',
                          style: body2.copyWith(color: AppColors.description),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.centerZoomFullBounds();
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
