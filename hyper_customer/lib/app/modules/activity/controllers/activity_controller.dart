import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/tab_views/moving_view.dart';
import '../views/tab_views/service_view.dart';
import '../views/tab_views/transaction_view.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = [
    const Tab(text: 'Giao dịch'),
    const Tab(text: 'Dịch vụ'),
    const Tab(text: 'Di chuyển'),
  ];

  final List<Widget> _screens = [
    const TransactionView(),
    const ServiceView(),
    const MovingView(),
  ];

  PageStorageBucket bucket = PageStorageBucket();
  Widget get currentScreen => _screens[tabController.index];

  void changeTab(int index) {
    tabController.index = index;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}
