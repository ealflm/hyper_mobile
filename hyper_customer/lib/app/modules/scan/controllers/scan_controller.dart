import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/modules/scan/models/scan_mode.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';

class ScanController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  var isFlashOn = false.obs;
  var scanMode = ScanMode.all.obs;

  @override
  void onInit() {
    HyperDialog.isOpen = false;
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('scanMode')) {
        scanMode.value = Get.arguments['scanMode'];
      }
    }
    super.onInit();
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      if (HyperDialog.isOpen) return;
      result = scanData;
      String? data = result?.code;

      HapticFeedback.lightImpact();

      if (data!.startsWith(AppValues.cardLinkQRPrefix) &&
          (scanMode.value == ScanMode.card || scanMode.value == ScanMode.all)) {
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
      } else if (data.startsWith(AppValues.rentingQRPrefix) &&
          (scanMode.value == ScanMode.renting ||
              scanMode.value == ScanMode.all)) {
        var code = data.substring(AppValues.rentingQRPrefix.length);
        qrController?.pauseCamera();
        await Get.toNamed(
          Routes.RENTING_FORM,
          arguments: {'code': code},
        );
        await qrController?.resumeCamera();
      } else if (data.startsWith(AppValues.busQRPrefix) &&
          (scanMode.value == ScanMode.busing ||
              scanMode.value == ScanMode.all)) {
        var code = data.substring(AppValues.rentingQRPrefix.length);
        qrController?.pauseCamera();

        await Get.offNamed(
          Routes.BUS_PAYMENT,
          arguments: {
            'code': code,
            'fromBusing': scanMode.value == ScanMode.busing,
          },
        );

        await qrController?.resumeCamera();
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
}
