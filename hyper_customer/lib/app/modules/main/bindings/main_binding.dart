import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_customer/app/modules/package/controllers/package_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<PackageController>(
      () => PackageController(),
    );
  }
}
