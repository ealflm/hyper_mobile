import 'package:get/get.dart';

class PaymentStatusController extends GetxController {
  bool state = false;
  @override
  void onInit() {
    if (Get.arguments != null) {
      state = Get.arguments['status'];
    }
    super.onInit();
  }
}
