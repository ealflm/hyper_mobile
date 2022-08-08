import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/models/activity_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

import '../views/tab_views/moving_view.dart';
import '../views/tab_views/service_view.dart';
import '../views/tab_views/transaction_view.dart';

class ActivityController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final Repository _repository = Get.find(tag: (Repository).toString());

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
    fetchActivity();
    super.onInit();
  }

  Rx<Activity?> activity = Rx<Activity?>(null);

  Future<void> fetchActivity() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;

    var activityService = _repository.getActivity(customerId);

    Activity? result;

    await callDataService(
      activityService,
      onSuccess: (Activity response) {
        result = response;
      },
      onError: (DioError dioError) {},
    );

    bool flag = false;
    for (Transactions item in result?.transactions ?? []) {
      if (item.createdDate?.difference(DateTime.now()).inDays == 0 &&
          flag == false) {
        item.filter = 0;
        flag = true;
      }
      if (item.createdDate?.difference(DateTime.now()).inDays != 0 &&
          flag == true) {
        item.filter = 1;
        break;
      }
    }

    activity(result);
  }
}
