import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/setting_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/widgets/dialog.dart';
import 'package:hyper_customer/app/data/models/auth_model.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  String? token;
  String? password;
  var phoneNumber = ''.obs;
  String fullName = '';

  @override
  void onInit() {
    if (Get.arguments != null) {
      phoneNumber.value = Get.arguments['phoneNumber'];
    }
    if (TokenManager.instance.hasUser) {
      User user = TokenManager.instance.user!;
      fullName = '${user.firstName} ${user.lastName}';
      if (phoneNumber.value.isEmpty) {
        phoneNumber.value = user.phone ?? '';
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    if (phoneNumber.value.isEmpty) Get.offAllNamed(Routes.START);
    super.onReady();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    var loginService = _repository.login(phoneNumber.value, password!);

    await callDataService(
      loginService,
      onSuccess: (Auth? response) {
        token = response?.token;
      },
      onError: (DioError dioError) {
        var response = dioError.response;

        if (response != null &&
            response.data.toString().isNotEmpty &&
            response.data['detail'] == 'Invalid user name or password') {
          HyperDialog.show(
            title: 'Sai mã PIN',
            content: 'Mã PIN bạn vừa nhập chưa chính xác. Vui lòng thử lại',
            buttonText: 'OK',
          );
        } else {
          Utils.showToast('Kết nối thất bại');
        }
      },
    );

    if (token != null) {
      TokenManager.instance.saveToken(token);
      TokenManager.instance.saveUser(token);
      Get.offAllNamed(Routes.MAIN);
    }
  }

  void back() {
    TokenManager.instance.clearUser();
    Get.offAllNamed(Routes.START);
  }
}
