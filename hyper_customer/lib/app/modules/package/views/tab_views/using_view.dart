import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
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
      child: Obx(
        () {
          return controller.currentPackage.value != null
              ? SizedBox(
                  height: 1.sh -
                      AppValues.bottomAppBarHeight -
                      statusBarHeight -
                      114.h,
                  width: double.infinity,
                  child: SmartRefresher(
                    controller: refreshController,
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      await controller.getCurrentPackage();
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
                                style: subtitle1.copyWith(
                                    fontWeight: FontWeights.light),
                              ),
                              Text(
                                '${controller.currentPackage.value?.packageName}',
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
                                  GetBuilder<PackageController>(
                                    builder: (_) {
                                      return Text(
                                        DateTimeUtils.counter(
                                          controller.currentPackage.value
                                              ?.packageExpireTimeStamp,
                                        ),
                                        style: subtitle1.copyWith(
                                            color: AppColors.lightBlack),
                                      );
                                    },
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
                                value: controller.currentDistance,
                                total: controller.limitDistances,
                                unit: 'Km',
                                animation: controller.buildCounter.value == 1,
                                isDisable: (controller.currentDistance >=
                                        controller.limitDistances ||
                                    controller.currentCardSwipes >=
                                        controller.limitCardSwipes),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              PackageStatusItem(
                                icon: Icons.credit_card,
                                title: 'Quẹt thẻ',
                                value: controller.currentCardSwipes,
                                total: controller.limitCardSwipes,
                                unit: 'lần',
                                animation: controller.buildCounter.value == 1,
                                isDisable: (controller.currentDistance >=
                                        controller.limitDistances ||
                                    controller.currentCardSwipes >=
                                        controller.limitCardSwipes),
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
                                    'Đặt xe',
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
                                value: controller.currentNumberOfTrips,
                                total: controller.limitNumberOfTrips,
                                unit: 'chuyến',
                                percent: controller.currentPackage.value
                                        ?.discountValueTrip ??
                                    0,
                                animation: controller.buildCounter.value == 1,
                                isDisable: (controller.currentNumberOfTrips >=
                                    controller.limitNumberOfTrips),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 1.sh -
                      AppValues.bottomAppBarHeight -
                      statusBarHeight -
                      114.h,
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
                        Container(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Bạn không sử dụng gói dịch vụ nào',
                              style: body2.copyWith(
                                color: AppColors.description,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
