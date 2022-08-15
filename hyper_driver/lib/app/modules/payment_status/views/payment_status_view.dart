import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_animation_assets.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/core/widgets/unfocus.dart';
import 'package:hyper_driver/app/modules/payment_status/controllers/payment_status_controller.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.paymentResult.status
                              ? _successful()
                              : _failed(),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _failed() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.error404,
              height: 200.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Giao dịch thất bại',
              style: h6.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            Text(
              'Đã có lỗi xảy ra trong quá trình giao dịch',
              style: subtitle1.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _successful() {
    return Column(
      children: [
        Column(
          children: [
            Lottie.asset(
              AppAnimationAssets.successful,
              repeat: false,
              height: 138.h,
            ),
            SizedBox(
              height: 10.h,
            ),
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
              controller.paymentResult.amountVND,
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
              controller.paymentResult.createdDateVN,
            ),
            const Divider(
              color: AppColors.line,
            ),
            _detailItem(
              'Mã giao dịch',
              controller.paymentResult.uid,
            ),
            const Divider(
              color: AppColors.line,
            ),
            _detailItem(
              'Dịch vụ',
              'Nạp tiền vào ví',
            ),
            const Divider(
              color: AppColors.line,
            ),
            _detailSourceItem(
              'Nguồn tiền',
              controller.paymentResult.source,
            ),
          ],
        ),
      ],
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

  Row _detailSourceItem(String key, int source) {
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
        source == 0
            ? Row(
                children: [
                  Text(
                    'PayPal',
                    style: subtitle2.copyWith(color: AppColors.softBlack),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SvgPicture.asset(
                    AppAssets.paypal,
                    height: 20.h,
                  ),
                ],
              )
            : source == 1
                ? Row(
                    children: [
                      Text(
                        'MoMo',
                        style: subtitle2.copyWith(color: AppColors.softBlack),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      SvgPicture.asset(
                        AppAssets.momo,
                        height: 20.h,
                      ),
                    ],
                  )
                : Container(),
      ],
    );
  }
}
