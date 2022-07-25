import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class Top extends GetWidget<RentingController> {
  const Top({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        switch (controller.rentingState.value) {
          case RentingState.normal:
            return _search();
          case RentingState.select:
            return _search();
          case RentingState.route:
            return _route();
          case RentingState.navigation:
            return _navigation();
          default:
            return Container();
        }
      },
    );
  }

  SafeArea _search() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 10.w,
          right: 10.w,
        ),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back();
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
                  Icons.arrow_back_ios_new,
                  size: 18.r,
                  color: AppColors.gray,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.RENTING_SEARCH);
                },
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: AppColors.surface,
                    boxShadow: ShadowStyles.map,
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputStyles.mapSearch(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 22.r,
                        color: AppColors.lightBlack,
                      ),
                      hintText: 'Tìm kiếm trạm',
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Vui lòng nhập mã PIN để tiếp tục';
                      }
                      return null;
                    },
                    // onSaved: (value) => controller.password = value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _route() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 10.w,
          right: 10.w,
        ),
        child: Container(
          decoration: BoxDecorations.map(),
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 5.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.clearRoute();
                    },
                    style: TextButton.styleFrom(
                      primary: AppColors.blue,
                      shape: const CircleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(0),
                      minimumSize: Size(40.r, 40.r),
                    ),
                    child: SizedBox(
                      height: 40.r,
                      width: 40.r,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.r,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 11.5.h),
                    height: 85.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _startIcon(),
                        _dotIcon(),
                        _dotIcon(),
                        _dotIcon(),
                        _endIcon(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 3.5.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  enabled: false,
                                  cursorColor: AppColors.blue,
                                  style: subtitle1.copyWith(
                                    color: AppColors.lightBlack,
                                  ),
                                  initialValue: 'Vị trí của bạn',
                                  decoration: InputStyles.map(
                                    hintText: 'Chọn điểm đi',
                                    labelText: 'Điểm đi',
                                  ),
                                ),
                                TextFormField(
                                  enabled: false,
                                  cursorColor: AppColors.blue,
                                  style: subtitle1.copyWith(
                                    color: AppColors.lightBlack,
                                  ),
                                  initialValue:
                                      controller.selectedStation?.title ?? '',
                                  decoration: InputStyles.map(
                                    hintText: 'Chọn điểm đến',
                                    labelText: 'Điểm đến',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w),
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: AppColors.blue,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.all(0),
                              minimumSize: Size(40.r, 40.r),
                            ),
                            child: SizedBox(
                              height: 40.r,
                              width: 40.r,
                              child: Icon(
                                Icons.swap_vert,
                                size: 23.r,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navigation() {
    return SafeArea(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () {
          controller.goBackFromNavigation();
        },
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  Container _startIcon() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 6, color: AppColors.blue),
      ),
    );
  }

  Container _dotIcon() {
    return Container(
      width: 3.r,
      height: 3.r,
      decoration: BoxDecoration(
        color: AppColors.indicator,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Container _endIcon() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.blue,
        border: Border.all(
          width: 6,
          color: AppColors.fadeBlue,
        ),
      ),
    );
  }
}
