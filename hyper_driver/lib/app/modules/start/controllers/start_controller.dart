import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class StartController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  String? phoneNumber;
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    var verifyService = _repository.verify(phoneNumber!);

    await callDataService(
      verifyService,
      onSuccess: (String response) {
        HyperDialog.show(
          title: 'Không tồn tại',
          content:
              'Số điện thoại không tồn tại. Liên hệ admin hệ thống để đăng ký',
          primaryButtonText: 'OK',
        );
      },
      onError: (DioError dioError) {
        var response = dioError.response;

        if (response != null &&
            response.data.toString().isNotEmpty &&
            response.data['message'] == 'Số điện thoại đã được sử dụng!') {
          Get.offAllNamed(Routes.LOGIN,
              arguments: {'phoneNumber': phoneNumber});
        } else {
          Utils.showToast('Kết nối thất bại');
        }
      },
    );
  }

  @override
  void onInit() {
    TokenManager.instance.clearUser();
    super.onInit();
  }
}
