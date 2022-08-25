import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/box_decorations.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/input_styles.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_button.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/core/widgets/unfocus.dart';

import '../controllers/start_controller.dart';

class StartView extends GetView<StartController> {
  const StartView({Key? key}) : super(key: key);
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
                          EdgeInsets.only(left: 30.w, top: 20.h, right: 30.w),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Hyper xin chào tài xế!', style: h6),
                              Text(
                                'Nhập số điện thoại để đăng nhập',
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
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Vui lòng nhập số điện thoại để tiếp tục';
                                      }
                                      if (!value.toString().startsWith('0') ||
                                          value.toString().length != 10) {
                                        return 'Nhập số điện thoại có 10 chữ số và bắt đầu bằng số 0';
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
