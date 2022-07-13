import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/package/widget/package_status_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/package_controller.dart';

class UsingView extends GetView<PackageController> {
  const UsingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;
    controller.increaseBuildCount();

    return SingleChildScrollView(
      child: SizedBox(
        height: 1.sh - AppValues.bottomAppBarHeight - statusBarHeight - 115.h,
        width: double.infinity,
        child: SmartRefresher(
          controller: refreshController,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            refreshController.refreshCompleted();
          },
          header: WaterDropMaterialHeader(
            distance: 50.h,
            backgroundColor: AppColors.softRed,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn đang sử dụng gói dịch vụ',
                      style: subtitle1.copyWith(fontWeight: FontWeights.light),
                    ),
                    Text(
                      'Gói siêu VIP',
                      style: subtitle1.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: AppColors.lightBlack,
                          size: 20.r,
                        ),
                        Text(
                          '16:04',
                          style:
                              subtitle1.copyWith(color: AppColors.lightBlack),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Đi xe buýt',
                          style: subtitle2.copyWith(
                            fontWeight: FontWeights.regular,
                            color: AppColors.description,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PackageStatusItem(
                      icon: Icons.moving,
                      title: 'Khoảng cách',
                      value: 6,
                      total: 30,
                      unit: 'Km',
                      animation: controller.buildCounter.value == 1,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    PackageStatusItem(
                      icon: Icons.credit_card,
                      title: 'Quẹt thẻ',
                      value: 4,
                      total: 5,
                      unit: 'lần',
                      animation: controller.buildCounter.value == 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Đi xe buýt',
                          style: subtitle2.copyWith(
                            fontWeight: FontWeights.regular,
                            color: AppColors.description,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PackageStatusItem(
                      icon: Icons.motorcycle,
                      title: 'Chuyến đi',
                      value: 5,
                      total: 15,
                      unit: 'chuyến',
                      animation: controller.buildCounter.value == 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
