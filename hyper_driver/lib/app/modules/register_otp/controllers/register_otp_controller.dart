import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_driver/app/data/models/user_model.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class RegisterOtpController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  String? token;
  String? password;
  var phoneNumber = ''.obs;
  var otp = ''.obs;
  var hasFocus = true.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      phoneNumber.value = Get.arguments['phoneNumber'];
    }
    focusNode.addListener(_onFocusChange);
    sendOtp();
    super.onInit();
  }

  @override
  void onReady() {
    if (phoneNumber.value.isEmpty) Get.offAllNamed(Routes.START);
    super.onReady();
  }

  @override
  void onClose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.onClose();
  }

  String requestId = '';

  void sendOtp() async {
    var sendOtpService = _repository.sendOtp(phoneNumber.value);

    await callDataService(
      sendOtpService,
      onSuccess: (String response) {
        requestId = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Không gửi được OTP');
      },
    );

    _startCounter();
  }

  var counter = 0.obs;
  Timer? countdownTimer;

  void _startCounter() {
    counter.value = 59;
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _setCountDown(),
    );
  }

  void _setCountDown() {
    counter.value--;
    if (counter.value <= 0) {
      countdownTimer?.cancel();
    }
  }

  void verifyOtp() async {
    bool result = false;
    var verifyOtpService = _repository.verifyOtp(
      phoneNumber.value,
      otp.value,
      requestId,
    );
    await callDataService(
      verifyOtpService,
      onSuccess: (bool response) {
        result = true;
      },
      onError: (DioError dioError) {
        HyperDialog.show(
          title: 'Không chính xác',
          content: 'Mã OTP không chính xác. Vui lòng nhập lại.',
          primaryButtonText: 'OK',
          primaryOnPressed: () {
            Get.back();
            focusNode.requestFocus();
          },
        );
      },
    );

    if (result == true) {
      goToRegister();
    }
  }

  var hasShowMessage = false.obs;

  void goToRegister() async {
    hasShowMessage.value = true;
    await Future.delayed(
      const Duration(seconds: 2),
    );
    Get.offAllNamed(Routes.REGISTER, arguments: {
      'phoneNumber': phoneNumber.value,
    });
  }

  void focus() {
    focusNode.requestFocus();
  }

  void onTextChanged(String value) {
    otp.value = value;
  }

  String getDigit(int index) {
    if (otp.value.length > index) {
      return otp.value[index];
    }
    return '';
  }

  bool isFocus(int index) {
    return otp.value.length == index && hasFocus.value;
  }

  void _onFocusChange() {
    hasFocus.value = focusNode.hasFocus;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    verifyOtp();
  }

  void back() {
    TokenManager.instance.clearUser();
    Get.offAllNamed(Routes.START);
  }
}
