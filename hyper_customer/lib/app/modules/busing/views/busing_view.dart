import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_controller.dart';

class BusingView extends GetView<BusingController> {
  const BusingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18.r,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            "Tìm đường",
            style: h6.copyWith(color: AppColors.softBlack),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.r),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Số chuyến tối đa',
                    style: subtitle2.copyWith(color: AppColors.softBlack),
                  ),
                  Row(
                    children: [
                      Text(
                        '2',
                        style: subtitle2.copyWith(color: AppColors.softBlack),
                      ),
                      Icon(Icons.chevron_right, size: 26.r),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyles.primaryMedium(),
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.submit();
                        },
                  child: HyperButton.child(
                    status: controller.isLoading,
                    child: Text(
                      'Tìm ngay',
                      style: buttonBold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
