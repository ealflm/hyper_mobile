import 'package:get/get.dart';
import 'package:hyper_customer/app/core/model/payment_result.dart';

class PaymentStatusController extends GetxController {
  PaymentResult paymentResult = PaymentResult();

  @override
  void onInit() {
    if (Get.arguments != null) {
      paymentResult = Get.arguments['paymentResult'];
    }
    super.onInit();
  }
}
