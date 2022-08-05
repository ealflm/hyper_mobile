import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/auth_model.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class RegisterController extends BaseController
    with GetSingleTickerProviderStateMixin {
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
            primaryButtonText: 'OK',
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

  // Region Tab

  var step = 0.obs;

  void changeStep(int step) {
    this.step.value = step;
  }

  // End Region

  // Region Scan

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  var isFlashOn = false.obs;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      if (HyperDialog.isOpen) return;
      result = scanData;
      String? data = result?.code;

      HapticFeedback.lightImpact();

      if (data!.startsWith(AppValues.cardLinkQRPrefix)) {
        var code = data.substring(AppValues.cardLinkQRPrefix.length);
        qrController?.pauseCamera();
        HyperDialog.show(
          title: 'Liên kết thẻ',
          content: 'Bạn có chắc chắn muốn liên kết thẻ này hay không?',
          primaryButtonText: 'Đồng ý',
          secondaryButtonText: 'Huỷ',
          primaryOnPressed: () {
            Get.offAllNamed(
              Routes.SCAN_CARD,
              arguments: {'code': code},
            );
          },
          secondaryOnPressed: () async {
            await qrController?.resumeCamera();
            Get.back();
          },
        );
      } else if (data.startsWith(AppValues.rentingQRPrefix)) {
        var code = data.substring(AppValues.rentingQRPrefix.length);
        qrController?.pauseCamera();
        await Get.toNamed(
          Routes.RENTING_FORM,
          arguments: {'code': code},
        );
        await qrController?.resumeCamera();
      } else if (data.startsWith(AppValues.busQRPrefix)) {
        var code = data.substring(AppValues.rentingQRPrefix.length);
        qrController?.pauseCamera();

        HyperDialog.show(
          title: 'Thanh toán vé xe buýt',
          content: 'Bạn có chắc chắn muốn thanh toán vé xe buýt này không?',
          primaryButtonText: 'Đồng ý',
          secondaryButtonText: 'Huỷ',
          primaryOnPressed: () async {
            await Get.toNamed(
              Routes.BUS_PAYMENT,
              arguments: {'code': code},
            );
            await qrController?.resumeCamera();
          },
          secondaryOnPressed: () async {
            await qrController?.resumeCamera();
            Get.back();
          },
        );
      } else {
        HyperDialog.show(
          title: 'Không hỗ trợ',
          content: 'Hyper không hỗ trợ đọc QR code này',
          primaryButtonText: 'Đồng ý',
          primaryOnPressed: () async {
            await qrController?.resumeCamera();
            Get.back();
          },
        );
      }
    });
  }

  void toggleFlash() async {
    if (qrController != null) {
      await qrController?.toggleFlash();
      isFlashOn.value = await qrController?.getFlashStatus() ?? false;
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  // End Region
}
