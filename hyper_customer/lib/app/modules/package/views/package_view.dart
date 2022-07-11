import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/package_controller.dart';

class PackageView extends GetView<PackageController> {
  const PackageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PackageView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PackageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
