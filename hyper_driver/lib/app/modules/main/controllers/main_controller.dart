import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/setting_controller.dart';
import 'package:hyper_driver/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_driver/app/modules/account/views/account_view.dart';
import 'package:hyper_driver/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_driver/app/modules/activity/views/activity_view.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_driver/app/modules/home/views/home_view.dart';

class MainController extends GetxController {
  late HomeController _homeController;
  late ActivityController _activityController;
  late AccountController _accountController;

  var currentTab = 0.obs;
  final List<Widget> _screens = [
    const HomeView(),
    const ActivityView(),
    const AccountView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[currentTab.value];

  var activityState = false.obs;
  var activityLoading = false.obs;

  @override
  void onInit() async {
    initController();

    await SettingController.intance.init();

    super.onInit();
  }

  void initController() {
    Get.put(
      HomeController(),
      permanent: true,
    );
    _homeController = Get.find<HomeController>();
    _homeController.init();

    Get.put(
      ActivityController(),
      permanent: true,
    );
    _activityController = Get.find<ActivityController>();
    _activityController.init();

    Get.put(
      AccountController(),
      permanent: true,
    );
    _accountController = Get.find<AccountController>();
    _accountController.init();
  }

  void changeTab(int index) {
    currentTab.value = index;
    switch (index) {
      case 0:
        _homeController.init();
        break;
      case 2:
        _activityController.init();
        break;
      case 3:
        _accountController.init();
        break;
    }
  }

  void toggleActivityState() async {
    activityLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    activityLoading.value = false;
    activityState.value = !activityState.value;
  }
}
