import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/input_styles.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_button.dart';
import 'package:hyper_driver/app/core/widgets/light_bulb.dart';
import 'package:hyper_driver/app/modules/register/controllers/register_controller.dart';

class CreatePin extends GetView<RegisterController> {
  const CreatePin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _body(),
          _bottom(),
        ],
      ),
    );
  }

  Widget _bottom() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.h,
      ),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyles.primary(),
                onPressed: controller.pageLoading.value
                    ? null
                    : () async {
                        await controller.submit();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                child: HyperButton.child(
                  status: controller.pageLoading.value,
                  child: Text(
                    'Tạo tài khoản',
                    style: buttonBold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tạo',
              style: h5.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              'mã PIN đăng nhập',
              style: h5.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            const LightBulb(
              message: 'Mã PIN gồm 6 chữ số',
              isCenter: true,
            ),
            SizedBox(
              height: 30.h,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '●',
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputStyles.roundBorder(
                prefixIcon: const Icon(Icons.key),
                hintText: "Nhập mã PIN",
              ),
              maxLength: 6,
              validator: (value) {
                if (value.toString().isEmpty) {
                  return 'Vui lòng nhập mã PIN để tiếp tục';
                }
                if (value.toString().length != 6) {
                  return 'Vui lòng nhập 6 chữ số';
                }
                return null;
              },
              onSaved: (value) => controller.password = value,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
