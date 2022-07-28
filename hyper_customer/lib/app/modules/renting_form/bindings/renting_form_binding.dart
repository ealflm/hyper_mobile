import 'package:get/get.dart';

import '../controllers/renting_form_controller.dart';

class RentingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentingFormController>(
      () => RentingFormController(),
    );
  }
}
