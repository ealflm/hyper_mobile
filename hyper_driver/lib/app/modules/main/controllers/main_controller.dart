import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/controllers/notification_controller.dart';
import 'package:hyper_driver/app/core/controllers/setting_controller.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller_bak.dart';
import 'package:hyper_driver/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_driver/app/modules/account/views/account_view.dart';
import 'package:hyper_driver/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_driver/app/modules/activity/views/activity_view.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_driver/app/modules/package/controllers/package_controller.dart';
import 'package:hyper_driver/app/modules/package/views/package_view.dart';

class MainController extends GetxController {
  late HomeController _homeController;
  late ActivityController _activityController;
  late PackageController _packageController;
  late AccountController _accountController;

  var currentTab = 0.obs;
  final List<Widget> _screens = [
    Container(),
    const ActivityView(),
    const PackageView(),
    const AccountView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[currentTab.value];

  var activityState = false.obs;
  var activityLoading = false.obs;

  @override
  void onInit() async {
    if (Get.parameters['appInit'] == 'true') {
      SignalR.instance.start();
      NotificationController.instance.registerNotification();
    }

    initController();

    await SettingController.intance.init();
    HyperMapController.instance.init();

    super.onInit();
  }

  @override
  void onClose() {
    SignalR.instance.stopStreamDriverLocation();
    super.onClose();
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
      PackageController(),
      permanent: true,
    );
    _packageController = Get.find<PackageController>();
    _packageController.init();

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
      case 4:
        _accountController.init();
        break;
    }
  }

  void toggleActivityState() async {
    activityLoading.value = true;

    if (activityState.value == false) {
      SignalR.instance.streamDriverLocation();
    } else {
      SignalR.instance.closeDriver();
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    activityLoading.value = false;
    activityState.value = !activityState.value;
    _homeController.setActivityState(activityState.value);
  }
}
