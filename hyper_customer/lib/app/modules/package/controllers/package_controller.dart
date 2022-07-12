import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/package/views/explore_view.dart';
import 'package:hyper_customer/app/modules/package/views/using_view.dart';

class PackageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = [
    const Tab(text: 'Đang sử dụng'),
    const Tab(text: 'Khám phá thêm'),
  ];

  final List<Widget> _screens = [
    const UsingView(),
    const ExploreView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[tabController.index];

  var buildCounter = 0.obs;

  void increaseBuildCount() {
    buildCounter.value++;
  }

  void changeTab(int index) {
    tabController.index = index;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
