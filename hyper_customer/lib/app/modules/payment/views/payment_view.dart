import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/payment/widgets/payment_radio_item.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: AppColors.softBlack,
                                  ),
                                  onPressed: () {
                                    Get.offAllNamed(Routes.MAIN);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text('Nạp tiền vào ví',
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
                      padding:
                          EdgeInsets.only(left: 30.w, top: 20.h, right: 30.w),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            _balance(),
                            SizedBox(
                              height: 20.h,
                            ),
                            _deposit(),
                            SizedBox(
                              height: 20.h,
                            ),
                            _source(),
                            SizedBox(
                              height: 20.h,
                            ),
                            _action(),
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

  Obx _action() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyles.primary(),
          onPressed: controller.submitIsLoading.value
              ? null
              : () {
                  controller.submit();
                },
          child: HyperButton.child(
            status: controller.submitIsLoading.value,
            child: Text(
              'Nạp tiền',
              style: buttonBold,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _source() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nguồn tiền',
            style: subtitle1.copyWith(
              fontWeight: FontWeights.medium,
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          GetBuilder<PaymentController>(
            builder: (_) {
              return Column(
                children: [
                  PaymentRadioItem(
                    onPressed: () {
                      controller.changePaymentMethod(1);
                    },
                    state: controller.selectedPaymentMethod == 1,
                    svgAsset: AppAssets.momo,
                    title: 'MoMo',
                    description: 'Thanh toán đa dạng',
                  ),
                  PaymentRadioItem(
                    onPressed: () {
                      controller.changePaymentMethod(0);
                    },
                    state: controller.selectedPaymentMethod == 0,
                    svgAsset: AppAssets.paypal,
                    title: 'PayPal',
                    description: 'Thanh toán quốc tế',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Column _deposit() {
    return Column(
      children: [
        GetBuilder<PaymentController>(
          builder: (_) {
            return TextFormField(
              validator: (text) {
                if (text.toString().isEmpty) {
                  return 'Vui lòng nhập số tiền để tiếp tục';
                }
                double value = controller.getDouble(text!);
                if (value < 5000) {
                  return 'Số tiền tối thiểu là 5.000 VNĐ';
                }
                if (value > 50000000) {
                  return 'Số tiền tối đa là 50.000.000 VNĐ';
                }
                return null;
              },
              maxLength: 10,
              onSaved: (value) => controller.depositText = value,
              focusNode: controller.depositFocusNode,
              controller: controller.depositController,
              decoration: InputStyles.softBorder(
                labelText: "Số tiền cần nạp",
                state: controller.isShowClear,
                suffixAction: () {
                  controller.changeDeposit('');
                },
              ),
              style: subtitle1.copyWith(
                color: AppColors.softBlack,
                fontWeight: FontWeights.medium,
                fontSize: 18.sp,
              ),
              inputFormatters: [
                CurrencyTextInputFormatter(
                  decimalDigits: 0,
                  locale: 'vi',
                  symbol: '',
                )
              ],
              keyboardType: TextInputType.number,
            );
          },
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _paymentChip(
                '100.000',
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: _paymentChip(
                '200.000',
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: _paymentChip(
                '500.000',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentChip(String text) {
    return TextButton(
      onPressed: () {
        controller.changeDeposit(text);
      },
      style: ButtonStyles.paymentChip(),
      child: Center(
        child: Text(
          '$text đ',
          style: body2.copyWith(
            color: AppColors.lightBlack,
          ),
        ),
      ),
    );
  }

  Row _balance() {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.hyperLogo,
          width: 36.w,
          height: 36.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Số dư ví Hyper',
              style: body2.copyWith(color: AppColors.floatLabel),
            ),
            GetBuilder<PaymentController>(
              builder: (_) {
                Widget result = Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      '1.000.000 VNĐ',
                      style: subtitle2.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
                  ),
                );
                if (controller.hasAccountBalance) {
                  result = Text(
                    controller.accountBlanceVND,
                    style: subtitle2.copyWith(
                      color: AppColors.softBlack,
                    ),
                  );
                }
                return result;
              },
            ),
          ],
        ),
      ],
    );
  }
}
