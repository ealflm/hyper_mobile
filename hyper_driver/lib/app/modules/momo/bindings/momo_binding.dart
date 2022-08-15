import 'package:get/get.dart';

import '../controllers/momo_controller.dart';

class MomoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MomoController>(
      () => MomoController(),
    );
  }
}
