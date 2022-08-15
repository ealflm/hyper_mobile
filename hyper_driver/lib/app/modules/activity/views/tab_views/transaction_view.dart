import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/data/models/activity_model.dart';
import 'package:hyper_driver/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_driver/app/modules/activity/widgets/transaction_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionView extends GetView<ActivityController> {
  const TransactionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Center(
      child: Obx(
        () => SizedBox(
          height: 1.sh - AppValues.bottomAppBarHeight - statusBarHeight - 115.h,
          width: double.infinity,
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              await controller.fetchActivity();
              refreshController.refreshCompleted();
            },
            header: WaterDropMaterialHeader(
              distance: 50.h,
              backgroundColor: AppColors.softRed,
            ),
            child: controller.activity.value != null &&
                    controller.activity.value!.transactions!.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        controller.activity.value?.transactions?.length ?? 0,
                    itemBuilder: (context, index) {
                      Transactions? item =
                          controller.activity.value?.transactions?[index];
                      if (item?.filter == 0) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    'Hôm nay',
                                    style: h6.copyWith(
                                        color: AppColors.softBlack,
                                        fontSize: 18.sp),
                                  ),
                                ],
                              ),
                            ),
                            TransactionItem(
                              model: item,
                            ),
                          ],
                        );
                      } else if (item?.filter == 1) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, top: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    'Trước đó',
                                    style: h6.copyWith(
                                        color: AppColors.softBlack,
                                        fontSize: 18.sp),
                                  ),
                                ],
                              ),
                            ),
                            TransactionItem(
                              model: item,
                            ),
                          ],
                        );
                      }
                      return TransactionItem(
                        model: controller.activity.value?.transactions?[index],
                      );
                    })
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          'Không có giao dịch',
                          style: body2.copyWith(
                            color: AppColors.description,
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
