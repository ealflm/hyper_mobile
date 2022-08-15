import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/modules/register/model/citizen_indentity_card.dart';
import 'package:hyper_driver/app/modules/register/model/view_state.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class RegisterController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  String? password;
  var phoneNumber = ''.obs;
  String userInfos = '';

  var state = ViewState.normal.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      phoneNumber.value = Get.arguments['phoneNumber'];
    }

    super.onInit();
  }

  @override
  void onReady() {
    if (phoneNumber.value.isEmpty) Get.offAllNamed(Routes.START);
    super.onReady();
  }

  var pageLoading = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    pageLoading.value = true;

    if (phoneNumber.value.isEmpty ||
        password == null ||
        citizenIdentityCard == null) {
      return;
    }

    var registerService = _repository.register(
      phoneNumber.value,
      password!,
      citizenIdentityCard!,
    );

    bool result = false;

    await callDataService(
      registerService,
      onSuccess: (bool response) {
        result = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    pageLoading.value = false;

    if (result) {
      state.value = ViewState.registerSuccess;
    }
  }

  void back() {
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

      if (data!.startsWith('0') && '|'.allMatches(data).length == 6) {
        qrController?.pauseCamera();

        userInfos = data;
        toModel(userInfos);
        Get.back();
        state.value = ViewState.scanSuccess;
        await Future.delayed(
          const Duration(
            seconds: 2,
          ),
        );
        state.value = ViewState.normal;
        changeStep(3);
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

  CitizenIdentityCard? citizenIdentityCard;

  void toModel(String value) {
    var data = value.split('|');
    citizenIdentityCard = CitizenIdentityCard.fromString(
      cccd: data[0],
      cmnd: data[1],
      name: data[2],
      birthDate: data[3],
      gender: data[4],
      address: data[5],
      createdDate: data[6],
    );
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
