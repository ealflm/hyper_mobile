import 'package:get/get.dart';

import '../controllers/bus_payment_controller.dart';

class BusPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusPaymentController>(
      () => BusPaymentController(),
    );
  }
}
