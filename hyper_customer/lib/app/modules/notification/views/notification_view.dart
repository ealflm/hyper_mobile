import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
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
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
              primary: AppColors.softBlack,
            ),
            onPressed: () {},
            child: Icon(
              Icons.delete_sweep_outlined,
              size: 26.r,
            ),
          ),
        ],
        title: GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            "Thông báo",
            style: h5.copyWith(color: AppColors.softBlack),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hôm nay',
                  style:
                      h6.copyWith(color: AppColors.softBlack, fontSize: 18.sp),
                ),
                const Text('Hello'),
              ],
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trước đó',
                  style:
                      h6.copyWith(color: AppColors.softBlack, fontSize: 18.sp),
                ),
                const Text('Hello'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
