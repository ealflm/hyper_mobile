import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  var isFlashOn = false.obs;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      String? data = result?.code;

      await qrController?.pauseCamera();

      if (data!.startsWith('0')) {
        HyperDialog.show(
          title: 'Liên kết thẻ',
          content: 'Bạn có chắc chắn muốn liên kết thẻ này hay không? $data',
          primaryButtonText: 'Đồng ý',
          secondaryButtonText: 'Huỷ',
          secondaryOnPressed: () async {
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
