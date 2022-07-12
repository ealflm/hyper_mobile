import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';

import '../controllers/package_controller.dart';

class PackageView extends GetView<PackageController> {
  const PackageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _header(),
                SizedBox(height: 8.h),
                GetBuilder<PackageController>(
                  init: PackageController(),
                  initState: (_) {},
                  builder: (_) {
                    return PageStorage(
                      bucket: controller.bucket,
                      child: controller.currentScreen,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 18.w,
                top: 10.h,
                right: 18.w,
              ),
              child: Text(
                'Gói dịch vụ',
                style: h5.copyWith(color: AppColors.softBlack),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 32.h,
          width: 327.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: TabBar(
            controller: controller.tabController,
            onTap: (index) {
              controller.changeTab(index);
            },
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: AppColors.primary400,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  color: AppColors.primary500.withOpacity(0.4),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.description,
            tabs: controller.tabs,
          ),
        ),
      ],
    );
  }
}
