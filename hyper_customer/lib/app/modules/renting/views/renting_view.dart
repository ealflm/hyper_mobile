import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';

import '../controllers/renting_controller.dart';

class RentingView extends GetView<RentingController> {
  const RentingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(children: [
          Container(
            color: AppColors.white,
          ),
          SafeArea(
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
                    child: Container(
                      height: 42.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: AppColors.surface,
                        boxShadow: ShadowStyles.mapSearch,
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
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
            child: ElevatedButton(
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
                  Icons.gps_fixed,
                  size: 18.r,
                  color: AppColors.gray,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
