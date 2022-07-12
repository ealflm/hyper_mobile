import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
