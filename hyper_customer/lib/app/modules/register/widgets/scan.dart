import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/light_bulb.dart';
import 'package:hyper_customer/app/core/widgets/qr_painter.dart';
import 'package:hyper_customer/app/modules/register/controllers/register_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scan extends GetView<RegisterController> {
  const Scan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(),
      ],
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quét',
              style: h5.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              'QR Code',
              style: h5.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            Text(
              'trên CCCD của bạn',
              style: h5.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            GestureDetector(
              onTap: () {
                controller.toggleFlash();
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                      color: AppColors.primary500,
                      width: 2.r,
                    ),
                  ),
                  width: 240.r,
                  height: 240.r,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.r),
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: 1.sw,
                          height: 1.sh,
                          child: Stack(
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            LightBulb(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mẹo khi quét:',
                    style: subtitle2.copyWith(color: AppColors.description),
                  ),
                  Text(
                    ' •  Đặt CCCD trên mặt phẳng',
                    style: body2.copyWith(color: AppColors.description),
                  ),
                  Text(
                    ' •  Tránh bị mờ, chói hoặc tối',
                    style: body2.copyWith(color: AppColors.description),
                  ),
                  Text(
                    ' •  Đặt QR bên trong khung hình',
                    style: body2.copyWith(color: AppColors.description),
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
