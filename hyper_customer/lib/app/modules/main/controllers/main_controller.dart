import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/setting_controller.dart';
import 'package:hyper_customer/app/core/model/payment_result.dart';
import 'package:hyper_customer/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_customer/app/modules/account/views/account_view.dart';
import 'package:hyper_customer/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_customer/app/modules/activity/views/activity_view.dart';
import 'package:hyper_customer/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_customer/app/modules/home/views/home_view.dart';
import 'package:hyper_customer/app/modules/package/controllers/package_controller.dart';
import 'package:hyper_customer/app/modules/package/views/package_view.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class MainController extends GetxController {
  late HomeController _homeController;
  late PackageController _packageController;
  late ActivityController _activityController;
  late AccountController _accountController;

  var currentTab = 0.obs;
  final List<Widget> _screens = [
    const HomeView(),
    const PackageView(),
    const ActivityView(),
    const AccountView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[currentTab.value];

  @override
  void onInit() async {
    initController();

    await SettingController.intance.init();

    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) {
      PaymentResult paymentResult = PaymentResult.fromString(
        status: uri.queryParameters['resultCode'],
        uid: uri.queryParameters['uid'],
        amount: uri.queryParameters['amount'],
        createdDate: uri.queryParameters['create-date'],
        source: 'momo',
      );

      Get.offAllNamed(
        Routes.PAYMENT_STATUS,
        arguments: {
          'paymentResult': paymentResult,
        },
      );
    });

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
      PackageController(),
      permanent: true,
    );
    _packageController = Get.find<PackageController>();
    _packageController.init();

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
      case 1:
        _packageController.init();
        break;
      case 2:
        _activityController.init();
        break;
      case 3:
        _accountController.init();
        break;
    }
  }
}
