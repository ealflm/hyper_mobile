import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/modules/main/widgets/nav_button.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => PageStorage(
          bucket: controller.bucket,
          child: controller.currentScreen,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 50.w,
        height: 50.w,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: AppColors.primary400,
            child: Icon(
              Icons.qr_code_scanner,
              size: 30.r,
            ),
            onPressed: () {
              Get.toNamed(Routes.SCAN);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.h,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          height: 60.h,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavButton(
                      title: 'Trang chủ',
                      icon: Icons.explore,
                      iconOutlined: Icons.explore_outlined,
                      onPressed: () {
                        controller.changeTab(0);
                      },
                      state: controller.currentTab.value == 0,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    NavButton(
                      title: 'Gói dịch vụ',
                      icon: AntIcons.giftFilled,
                      iconOutlined: AntIcons.giftOutlined,
                      onPressed: () {
                        controller.changeTab(1);
                      },
                      state: controller.currentTab.value == 1,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    NavButton(
                      title: 'Hoạt động',
                      icon: Icons.receipt_long,
                      iconOutlined: Icons.receipt_long_outlined,
                      onPressed: () {
                        controller.changeTab(2);
                      },
                      state: controller.currentTab.value == 2,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    NavButton(
                      title: 'Tài khoản',
                      icon: Icons.person,
                      iconOutlined: Icons.person_outlined,
                      onPressed: () {
                        controller.changeTab(3);
                      },
                      state: controller.currentTab.value == 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
