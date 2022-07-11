import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';

import '../controllers/start_controller.dart';

class StartView extends GetView<StartController> {
  const StartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.light,
      child: GestureDetector(
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
                    flex: 3875,
                    child: Container(
                      constraints: BoxConstraints(minHeight: 150.h),
                      child: SafeArea(
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.hyperWhiteLogo,
                            width: 100.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6125,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecorations.top(),
                      padding:
                          const EdgeInsets.only(left: 30, top: 20, right: 30),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Hyper xin chào!', style: h6),
                              Text(
                                'Nhập số điện thoại để đăng kí hoặc đăng nhập',
                                style: body2,
                              ),
                            ],
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
                                    decoration: InputStyles.roundBorder(
                                      prefixIcon: const Icon(Icons.phone),
                                      hintText: "Nhập số điện thoại",
                                    ),
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Vui lòng nhập số điện thoại để tiếp tục';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        controller.phoneNumber = value,
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
                                          child: Text('Tiếp tục',
                                              style: buttonBold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
}
