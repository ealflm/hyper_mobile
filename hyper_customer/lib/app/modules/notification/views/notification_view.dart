import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/notification_controller.dart';
import '../widgets/transaction_item.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);

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
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
              primary: AppColors.softBlack,
            ),
            onPressed: controller.clearNotifications,
            child: Icon(
              Icons.delete_sweep_outlined,
              size: 26.r,
            ),
          ),
        ],
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            "Thông báo",
            style: h5.copyWith(color: AppColors.softBlack),
          ),
        ),
      ),

      body: Obx(
        () => SizedBox(
          width: double.infinity,
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              await controller.fetchNotifications();
              refreshController.refreshCompleted();
            },
            header: WaterDropMaterialHeader(
              distance: 50.h,
              backgroundColor: AppColors.softRed,
            ),
            child: controller.notifications.value.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.notifications.value.length,
                    itemBuilder: (context, index) {
                      var item = controller.notifications.value[index];
                      if (item.filter == 0) {
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
                            NotificationItem(
                              model: item,
                            ),
                          ],
                        );
                      } else if (item.filter == 1) {
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
                            NotificationItem(
                              model: item,
                            ),
                          ],
                        );
                      }
                      return NotificationItem(
                        model: item,
                      );
                    })
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          'Không có thông báo',
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
