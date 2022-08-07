import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/qr_painter.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/scan/models/scan_mode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return StatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        body: Stack(
          children: [
            QRView(
              key: controller.qrKey,
              onQRViewCreated: controller.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 1.r,
                borderLength: 35.w,
                borderWidth: 10,
                cutOutSize: 200.r,
                overlayColor: AppColors.black.withOpacity(0),
              ),
            ),
            Center(
              child: CustomPaint(
                painter: QRPainter(),
                child: SizedBox(
                  width: 200.r,
                  height: 200.r,
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              top: 18.h + statusBarHeight,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: AppColors.cameraOverlay,
                ),
                child: SizedBox(
                  height: 40.r,
                  width: 40.r,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 94.h + statusBarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cameraOverlay,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Obx(
                      () {
                        switch (controller.scanMode.value) {
                          case ScanMode.renting:
                            return Text(
                              'Quét mã QR - Thuê xe',
                              style: subtitle1.copyWith(
                                fontWeight: FontWeights.medium,
                                color: AppColors.white,
                              ),
                            );
                          case ScanMode.busing:
                            return Text(
                              'Quét mã QR - Đi xe buýt',
                              style: subtitle1.copyWith(
                                fontWeight: FontWeights.medium,
                                color: AppColors.white,
                              ),
                            );
                          default:
                            return Text(
                              'Quét mã QR',
                              style: subtitle1.copyWith(
                                fontWeight: FontWeights.medium,
                                color: AppColors.white,
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 610.h + statusBarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.toggleFlash();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: AppColors.cameraOverlay,
                    ),
                    child: SizedBox(
                      height: 60.r,
                      width: 60.r,
                      child: Obx(
                        () => Icon(
                          controller.isFlashOn.value
                              ? Icons.flash_off_outlined
                              : Icons.flash_on_outlined,
                          size: 26.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: AppColors.cameraOverlay,
                    ),
                    child: SizedBox(
                      height: 60.r,
                      width: 60.r,
                      child: Icon(
                        Icons.collections_outlined,
                        size: 26.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
