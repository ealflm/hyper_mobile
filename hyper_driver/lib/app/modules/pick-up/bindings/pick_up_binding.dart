import 'package:get/get.dart';

import '../controllers/pick_up_controller.dart';

class PickUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickUpController>(
      () => PickUpController(),
    );
  }
}
