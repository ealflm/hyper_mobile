import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_animation_assets.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/widgets/hyper_stack.dart';
import 'package:hyper_driver/app/modules/home/views/home_view.dart';
import 'package:hyper_driver/app/modules/main/widgets/nav_button.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const HomeView(),
          Obx(
            () => PageStorage(
              bucket: controller.bucket,
              child: controller.currentScreen,
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => SizedBox(
          width: 50.w,
          height: 50.w,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: SignalR.instance.activityState.value
                  ? AppColors.primary400
                  : AppColors.softBlack,
              onPressed: controller.activityLoading.value
                  ? () {}
                  : () {
                      controller.toggleActivityState();
                    },
              child: controller.activityLoading.value
                  ? Lottie.asset(AppAnimationAssets.fourLoading, width: 25.w)
                  : Icon(
                      Icons.power_settings_new,
                      size: 30.r,
                    ),
            ),
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
                      title: 'Hoạt động',
                      icon: Icons.receipt_long,
                      iconOutlined: Icons.receipt_long_outlined,
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
                      title: 'Thông báo',
                      icon: Icons.notifications,
                      iconOutlined: Icons.notifications_outlined,
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
