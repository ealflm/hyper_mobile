import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                                  Get.offAllNamed(Routes.START);
                                  debugPrint('Pressed');
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
                          child: Text('Đăng nhập',
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
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: Column(
                      children: [
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Xin chào',
                                  style: h6.copyWith(fontSize: 18.sp),
                                ),
                                Text(
                                  controller.phoneNumber.value,
                                  style: body1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 280.w,
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  obscureText: true,
                                  obscuringCharacter: '●',
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  autofocus: true,
                                  decoration: InputStyles.roundBorder(
                                    prefixIcon: const Icon(Icons.key),
                                    hintText: "Nhập mã PIN",
                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Vui lòng nhập mã PIN để tiếp tục';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      controller.password = value,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyles.primary(),
                                      onPressed: controller.isLoading
                                          ? null
                                          : () {
                                              controller.submit();
                                            },
                                      child: HyperButton.child(
                                        status: controller.isLoading,
                                        child: Text('Đăng nhập',
                                            style: buttonBold),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Quên mã PIN',
                                    style: body2.copyWith(
                                      color: AppColors.primary600,
                                      fontWeight: FontWeights.medium,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    debugPrint('Fingerprint pressed');
                                    Get.offAllNamed(Routes.REGISTER);
                                  },
                                  style: ButtonStyles.fingerPrint(),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 55.w,
                                        height: 55.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const Icon(Icons.fingerprint,
                                          color: AppColors.white, size: 44),
                                    ],
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
    );
  }
}
