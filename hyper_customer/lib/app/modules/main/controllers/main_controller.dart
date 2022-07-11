import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/home/views/home_view.dart';
import 'package:hyper_customer/app/modules/package/views/package_view.dart';

class MainController extends GetxController {
  var currentTab = 0.obs;
  final List<Widget> _screens = [
    const HomeView(),
    const PackageView(),
    const PackageView(),
    const PackageView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[currentTab.value];

  void changeTab(int index) {
    currentTab.value = index;
  }
}
