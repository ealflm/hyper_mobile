import 'package:get/get.dart';

import '../controllers/busing_controller.dart';

class BusingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusingController>(
      () => BusingController(),
    );
  }
}
