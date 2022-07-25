import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/account/controllers/account_controller.dart';
import 'package:hyper_customer/app/modules/activity/controllers/activity_controller.dart';
import 'package:hyper_customer/app/modules/home/controllers/home_controller.dart';
import 'package:hyper_customer/app/modules/package/controllers/package_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      MainController(),
      permanent: true,
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
