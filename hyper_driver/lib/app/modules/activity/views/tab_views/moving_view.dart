import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_driver/app/modules/activity/widgets/transaction_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MovingView extends GetView<ActivityController> {
  const MovingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Center(
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
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: ListView(
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
