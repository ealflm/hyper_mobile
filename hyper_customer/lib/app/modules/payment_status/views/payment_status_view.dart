import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/payment_status/controllers/payment_status_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class PaymentStatusView extends GetView<PaymentStatusController> {
  const PaymentStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.light,
      child: Unfocus(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 400.h,
                color: AppColors.primary400,
              ),
              Column(
                children: [
                  Expanded(
                    flex: 20,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(
                            child: Text('Kết quả giao dịch',
                                style: h6.copyWith(color: AppColors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 80,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecorations.top(),
                      padding: EdgeInsets.only(
                          left: 30.w, top: 20.h, right: 30.w, bottom: 20.h),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Giao dịch thành công',
                                      style: subtitle1.copyWith(
                                        fontWeight: FontWeights.medium,
                                        color: AppColors.lightBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      '100.000 đ',
                                      style: h5.copyWith(
                                        fontWeight: FontWeights.medium,
                                        color: AppColors.softBlack,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  children: [
                                    _detailItem(
                                      'Thời gian thanh toán',
                                      '11:11 - 17/07/2022',
                                    ),
                                    const Divider(
                                      color: AppColors.line,
                                    ),
                                    _detailItem(
                                      'Mã giao dịch',
                                      '26455528012',
                                    ),
                                    const Divider(
                                      color: AppColors.line,
                                    ),
                                    _detailItem(
                                      'Dịch vụ',
                                      'Nạp tiền vào ví',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.offAllNamed(Routes.PAYMENT);
                                    },
                                    style: ButtonStyles.secondary(),
                                    child: Text(
                                      'Tiếp tục nạp tiền',
                                      style: buttonBold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.offAllNamed(Routes.MAIN);
                                    },
                                    style: ButtonStyles.primary(),
                                    child: Text(
                                      'Màn hình chính',
                                      style: buttonBold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _detailItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: subtitle2.copyWith(
            fontWeight: FontWeights.regular,
            color: AppColors.lightBlack,
          ),
        ),
        Text(
          value,
          style: subtitle2.copyWith(color: AppColors.softBlack),
        ),
      ],
    );
  }
}