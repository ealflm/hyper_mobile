import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final depositController = TextEditingController();
  var selectedPaymentMethod = 0.obs;

  void changeDeposit(String value) {
    depositController.text = value;
    depositController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: depositController.text.length,
      ),
    );
  }

  void changePaymentMethod(int value) {
    selectedPaymentMethod.value = value;
  }
}
