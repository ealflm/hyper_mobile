import 'package:get/get.dart';
import 'package:hyper_driver/app/modules/login/controllers/login_controller.dart';

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
  }
}
