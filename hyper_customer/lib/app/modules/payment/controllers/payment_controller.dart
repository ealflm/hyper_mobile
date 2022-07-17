import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class PaymentController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  final depositController = TextEditingController();
  final depositFocusNode = FocusNode();
  var depositHasFocus = false;
  var isEmpty = true;
  bool get isShowClear => depositHasFocus && !isEmpty;

  var selectedPaymentMethod = 1;
  String? depositText;

  @override
  void onInit() {
    depositFocusNode.addListener(_onFocusChange);
    depositController.addListener(_onTextChange);
    super.onInit();
  }

  @override
  void onClose() {
    depositFocusNode.removeListener(_onFocusChange);
    depositFocusNode.dispose();
    depositController.removeListener(_onTextChange);
    depositController.dispose();
    super.onClose();
  }

  void _onFocusChange() {
    depositHasFocus = depositFocusNode.hasFocus;
    update();
  }

  void _onTextChange() {
    isEmpty = depositController.text.isEmpty;
    update();
  }

  void changeDeposit(String value) {
    depositController.text = value;
    depositController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: depositController.text.length,
      ),
    );
  }

  void changePaymentMethod(int value) {
    selectedPaymentMethod = value;
    update();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    double depositValue =
        double.tryParse(depositText!.replaceAll('.', '')) ?? 0;

    User? user = TokenManager.instance.user;
    if (user == null) {
      Get.offAllNamed(Routes.START);
    }
    String customerId = user?.customerId ?? '';

    var depositService = _repository.deposit(
      depositValue,
      0,
      customerId,
    );

    String id = '';

    await callDataService(
      depositService,
      onSuccess: (String response) {
        id = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    if (id.isNotEmpty) {
      Get.toNamed(
        Routes.PAYPAL,
        arguments: {'id': id},
      );
    }
  }
}
