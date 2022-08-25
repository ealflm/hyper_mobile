import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/modules/package/widget/package_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/values/text_styles.dart';
import '../../controllers/package_controller.dart';

class ExploreView extends GetView<PackageController> {
  const ExploreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Center(
      child: Obx(
        () => controller.packages.value.isNotEmpty
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
                    await controller.fetchPackages();
                    refreshController.refreshCompleted();
                  },
                  header: WaterDropMaterialHeader(
                    distance: 50.h,
                    backgroundColor: AppColors.softRed,
                  ),
                  child: ListView.separated(
                    itemCount: controller.packages.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            PackageCard(controller.packages.value[index]),
                          ],
                        );
                      }
                      if (index == controller.packages.value.length - 1) {
                        return Column(
                          children: [
                            PackageCard(controller.packages.value[index]),
                            SizedBox(
                              height: 30.h,
                            ),
                          ],
                        );
                      }
                      return PackageCard(controller.packages.value[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Container(height: 24.h);
                    },
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
                        child: Center(
                          child: Text(
                            'Không có gói',
                            style: body2.copyWith(
                              color: AppColors.description,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
