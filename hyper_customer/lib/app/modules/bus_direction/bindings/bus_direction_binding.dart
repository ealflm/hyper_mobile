import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/bus_payment/controllers/bus_payment_controller.dart';

import '../controllers/bus_direction_controller.dart';

class BusDirectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusDirectionController>(
      () => BusDirectionController(),
    );
    Get.lazyPut<BusPaymentController>(
      () => BusPaymentController(),
    );
  }
}
