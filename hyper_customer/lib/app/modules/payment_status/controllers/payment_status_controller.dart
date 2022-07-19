import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';

class PaymentStatusController extends GetxController {
  bool state = false;
  String uid = '';
  double? amount;

  String get amountVND => Utils.vnd(amount);

  @override
  void onInit() {
    if (Get.arguments != null) {
      state = Get.arguments['status'] ?? false;
      uid = Get.arguments['uid'] ?? '';
      amount = Get.arguments['amount'];
    }
    super.onInit();
  }
}
