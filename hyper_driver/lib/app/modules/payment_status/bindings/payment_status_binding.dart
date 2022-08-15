import 'package:get/get.dart';

import '../controllers/payment_status_controller.dart';

class PaymentStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentStatusController>(
      () => PaymentStatusController(),
    );
  }
}
