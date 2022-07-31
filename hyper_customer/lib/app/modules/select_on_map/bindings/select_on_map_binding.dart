import 'package:get/get.dart';

import '../controllers/select_on_map_controller.dart';

class SelectOnMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectOnMapController>(
      () => SelectOnMapController(),
    );
  }
}
