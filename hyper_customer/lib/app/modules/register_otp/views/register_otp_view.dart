import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/core/widgets/hyper_message.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/register_otp/controllers/register_otp_controller.dart';

class RegisterOtpView extends GetView<RegisterOtpController> {
  const RegisterOtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => HyperMessage(
        hasShow: controller.hasShowMessage.value,
        child: _body(),
      ),
    );
  }

  StatusBar _body() {
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
                    flex: 25,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: ButtonStyles.textCircle(),
                                  onPressed: () {
                                    controller.back();
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
                            child: Text('Đăng ký',
                                style: h6.copyWith(color: AppColors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 85,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecorations.top(),
                      padding:
                          EdgeInsets.only(left: 30.w, top: 20.h, right: 30.w),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhập mã xác thực OTP',
                                  style: h6.copyWith(
                                    fontSize: 18.sp,
                                    color: AppColors.softBlack,
                                  ),
                                ),
                                Text(
                                  'Mã xác thực 4 số được gửi đến 0369085835',
                                  style: body2.copyWith(
                                    color: AppColors.lightBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                            width: 280.w,
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.focus();
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          color: AppColors.white.withOpacity(0),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 23.w,
                                          ),
                                          child: Obx(
                                            () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                OtpItem(
                                                  digit: controller.getDigit(0),
                                                  isFocus:
                                                      controller.isFocus(0),
                                                ),
                                                OtpItem(
                                                  digit: controller.getDigit(1),
                                                  isFocus:
                                                      controller.isFocus(1),
                                                ),
                                                OtpItem(
                                                  digit: controller.getDigit(2),
                                                  isFocus:
                                                      controller.isFocus(2),
                                                ),
                                                OtpItem(
                                                  digit: controller.getDigit(3),
                                                  isFocus:
                                                      controller.isFocus(3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 48.r,
                                          child: Opacity(
                                            opacity: 0,
                                            child: TextFormField(
                                              controller: controller
                                                  .textEditingController,
                                              focusNode: controller.focusNode,
                                              maxLength: 4,
                                              autofocus: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged:
                                                  controller.onTextChanged,
                                              validator: (value) {
                                                if (value.toString().length <
                                                    4) {
                                                  HyperDialog.show(
                                                    title: 'Chưa đủ 4 chữ số',
                                                    content:
                                                        'Vui lòng nhập đủ 4 chữ số',
                                                    primaryButtonText: 'OK',
                                                    primaryOnPressed: () {
                                                      Get.back();
                                                      controller.focusNode
                                                          .requestFocus();
                                                    },
                                                  );
                                                  return 'Error';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyles.primary(),
                                        onPressed: controller.isLoading
                                            ? null
                                            : () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                controller.submit();
                                              },
                                        child: HyperButton.child(
                                          status: controller.isLoading,
                                          child: Text(
                                            'Tiếp tục',
                                            style: buttonBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => controller.counter.value == 0
                                        ? TextButton(
                                            onPressed: () {
                                              controller.sendOtp();
                                            },
                                            child: Text(
                                              'Gửi lại OTP',
                                              style: body2.copyWith(
                                                color: AppColors.primary600,
                                                fontWeight: FontWeights.medium,
                                              ),
                                            ),
                                          )
                                        : TextButton(
                                            onPressed: null,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Gửi lại OTP ',
                                                  style: body2.copyWith(
                                                    color:
                                                        AppColors.description,
                                                    fontWeight:
                                                        FontWeights.medium,
                                                  ),
                                                ),
                                                Text(
                                                  '(00:${controller.counter.value.toString().padLeft(2, '0')})',
                                                  style: body2.copyWith(
                                                    color: AppColors.primary600,
                                                    fontWeight:
                                                        FontWeights.medium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpItem extends StatelessWidget {
  const OtpItem({
    Key? key,
    this.digit,
    this.isFocus = false,
  }) : super(key: key);

  final String? digit;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: digit != null && digit != '' && !isFocus
            ? AppColors.primary400
            : AppColors.otp,
        shape: BoxShape.circle,
        border: isFocus
            ? Border.all(
                color: AppColors.primary400,
                width: 2.r,
              )
            : const Border(),
      ),
      child: Text(
        digit ?? '',
        style: h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
