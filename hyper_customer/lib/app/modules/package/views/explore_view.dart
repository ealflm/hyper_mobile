import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';

import '../controllers/package_controller.dart';

class ExploreView extends GetView<PackageController> {
  const ExploreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.red,
      height: 1.sh - AppValues.bottomAppBarHeight - statusBarHeight - 115.h,
      width: double.infinity,
      child: const Text('Explore'),
    );
  }
}
