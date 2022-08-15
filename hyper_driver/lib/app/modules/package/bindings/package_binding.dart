import 'package:get/get.dart';

import '../controllers/package_controller.dart';

class PackageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackageController>(
      () => PackageController(),
    );
  }
}
