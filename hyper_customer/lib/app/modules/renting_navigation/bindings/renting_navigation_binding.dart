import 'package:get/get.dart';

import '../controllers/renting_navigation_controller.dart';

class RentingNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentingNavigationController>(
      () => RentingNavigationController(),
    );
  }
}
