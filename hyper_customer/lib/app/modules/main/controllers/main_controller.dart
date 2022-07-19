import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/setting_controller.dart';
import 'package:hyper_customer/app/modules/account/views/account_view.dart';
import 'package:hyper_customer/app/modules/activity/views/activity_view.dart';
import 'package:hyper_customer/app/modules/home/views/home_view.dart';
import 'package:hyper_customer/app/modules/package/views/package_view.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class MainController extends GetxController {
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
    await SettingController.intance.init();

    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) {
      var result = false;
      String? resultCode = uri.queryParameters['resultCode'];
      if (resultCode == '0') {
        result = true;
      }
      String? uid = uri.queryParameters['uid'];
      double? amount = double.tryParse(uri.queryParameters['amount'] ?? '');
      Get.offAllNamed(
        Routes.PAYMENT_STATUS,
        arguments: {
          'status': result,
          'uid': uid,
          'amount': amount,
        },
      );
    });

    super.onInit();
  }

  void changeTab(int index) {
    currentTab.value = index;
  }
}
