import 'package:get/get.dart';
import 'package:hyper_driver/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_driver/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_driver/app/modules/package/controllers/package_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      MainController(),
    );
    Get.put(
      HomeController(),
      permanent: true,
    );
    Get.put(
      PackageController(),
      permanent: true,
    );
    Get.put(
      ActivityController(),
      permanent: true,
    );
    Get.put(
      AccountController(),
      permanent: true,
    );
  }
}
