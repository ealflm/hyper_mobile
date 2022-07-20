import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: controller.qrKey,
              onQRViewCreated: controller.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 1.r,
                borderLength: 35.w,
                borderWidth: 10,
                cutOutSize: 200.w,
                overlayColor: AppColors.black.withOpacity(1),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GetBuilder<ScanController>(
              builder: (_) {
                return Center(
                  child: (controller.result != null)
                      ? Text(
                          'Barcode Type: ${describeEnum(controller.result!.format)}   Data: ${controller.result!.code}')
                      : Text('Scan a code'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
