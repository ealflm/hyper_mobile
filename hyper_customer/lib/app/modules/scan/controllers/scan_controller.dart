import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      update();
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
