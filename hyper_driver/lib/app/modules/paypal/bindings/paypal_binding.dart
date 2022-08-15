import 'package:get/get.dart';

import '../controllers/paypal_controller.dart';

class PaypalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaypalController>(
      () => PaypalController(),
    );
  }
}
