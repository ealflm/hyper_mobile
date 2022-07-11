import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';

import '../controllers/package_controller.dart';

class PackageView extends GetView<PackageController> {
  const PackageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Center(
          child: Text(
            'PackageView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
