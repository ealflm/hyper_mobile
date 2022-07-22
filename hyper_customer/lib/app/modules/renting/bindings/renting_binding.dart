import 'package:get/get.dart';

import '../controllers/renting_controller.dart';

class RentingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentingController>(
      () => RentingController(),
    );
  }
}
