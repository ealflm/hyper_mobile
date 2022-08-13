import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/current_package_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/package/views/tab_views/explore_view.dart';
import 'package:hyper_customer/app/modules/package/views/tab_views/using_view.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

import '../../../data/models/package_model.dart';

class PackageController extends BaseController
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
    init();
    super.onInit();
  }

  void init() {
    fetchPackages();
    getCurrentPackage();
  }

  final Repository _repository = Get.find(tag: (Repository).toString());

  Rx<List<Package>> packages = Rx<List<Package>>([]);

  Future<void> fetchPackages() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    var packageService = _repository.getPackages(customerId);

    await callDataService(
      packageService,
      onSuccess: (List<Package> response) {
        packages(response);
      },
      onError: (dioError) {},
    );
  }

  Future<void> buyPackage(String packageId) async {
    String customerId = TokenManager.instance.user?.customerId ?? '';

    var buyPackageService = _repository.buyPackage(customerId, packageId);

    await callDataService(
      buyPackageService,
      onSuccess: (bool response) {
        HyperDialog.show(
          title: 'Thành công',
          content: 'Áp dụng gói thành công',
          primaryButtonText: 'OK',
        );
      },
      onError: (DioError dioError) {
        var response = dioError.response;

        if (response?.statusCode == 400) {
          if (response?.data['message'].contains('Thanh toán thất bại')) {
            HyperDialog.show(
              title: 'Thất bại',
              content:
                  'Số dư không đủ. Vui lòng nạp thêm tiền để thực hiện giao dịch',
              primaryButtonText: 'OK',
            );
          }
          if (response?.data['message']
              .contains('Khách hàng không thể mua thêm gói dịch vụ')) {
            HyperDialog.show(
              title: 'Thất bại',
              content:
                  'Vui lòng sử dụng hết gói dịch vụ hiện tại trước khi mua gói mới',
              primaryButtonText: 'OK',
            );
          }
        } else {
          HyperDialog.show(
            title: 'Thất bại',
            content: 'Đã có lỗi xảy ra trong quá trình xử lý',
            primaryButtonText: 'OK',
          );
        }
      },
    );
  }

  Rx<CurrentPackage?> currentPackage = Rx<CurrentPackage?>(null);

  Future<void> getCurrentPackage() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var currentPackageService = _repository.getCurrentPackage(customerId);

    await callDataService(
      currentPackageService,
      onSuccess: (CurrentPackage response) {
        currentPackage(response);
      },
      onError: (dioError) {},
    );

    if (currentPackage.value != null) {
      double? value = currentPackage.value?.packageExpireTimeStamp;
      if (value == null) return;
      counter.value = value;
      countdownTimer?.cancel();
      _startCounter();
    }
  }

  int get currentDistance =>
      ((currentPackage.value?.currentDistances ?? 0) / 1000).round();
  int get limitDistances => currentPackage.value?.limitDistances ?? 0;
  int get currentCardSwipes => currentPackage.value?.currentCardSwipes ?? 0;
  int get limitCardSwipes => currentPackage.value?.limitCardSwipes ?? 0;
  int get currentNumberOfTrips =>
      currentPackage.value?.currentNumberOfTrips ?? 0;
  int get limitNumberOfTrips => currentPackage.value?.limitNumberOfTrips ?? 0;

  var counter = 0.0.obs;
  Timer? countdownTimer;

  void _startCounter() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _setCountDown(),
    );
  }

  void _setCountDown() {
    counter.value -= 1;
    if (counter.value <= (DateTime.now().millisecondsSinceEpoch / 1000)) {
      countdownTimer?.cancel();
    }
    update();
  }
}
