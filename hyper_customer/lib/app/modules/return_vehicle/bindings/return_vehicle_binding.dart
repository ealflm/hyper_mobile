import 'package:get/get.dart';

import '../controllers/return_vehicle_controller.dart';

class ReturnVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReturnVehicleController>(
      () => ReturnVehicleController(),
    );
  }
}
