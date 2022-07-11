import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/login/controllers/login_controller.dart';
import 'package:hyper_customer/app/modules/register/controllers/register_controller.dart';

import '../controllers/start_controller.dart';

class StartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartController>(
      () => StartController(),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}
