import 'package:get/get.dart';

import '../controllers/bus_direction_controller.dart';

class BusDirectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusDirectionController>(
      () => BusDirectionController(),
    );
  }
}
