import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/light_bulb.dart';
import 'package:hyper_driver/app/modules/register/controllers/register_controller.dart';

class ConfirmInfo extends GetView<RegisterController> {
  const ConfirmInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(),
        _bottom(),
      ],
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyles.primary(),
              onPressed: () {
                controller.changeStep(4);
              },
              child: Text(
                'Xác nhận',
                style: buttonBold,
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
              'Kiểm tra',
              style: h5.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              'thông tin cá nhân',
              style: h5.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            const LightBulb(
              message:
                  'Hãy chắc chắn rằng những thông tin bên dưới trùng khớp với thông tin thể hiện trên giấy tờ tuỳ thân',
            ),
            SizedBox(
              height: 30.h,
            ),
            _textField(
              label: 'Họ và tên',
              value: controller.citizenIdentityCard?.name ?? '-',
            ),
            SizedBox(height: 16.h),
            _textField(
              label: 'Ngày sinh',
              value: controller.citizenIdentityCard?.birthDateStr ?? '-',
            ),
            SizedBox(height: 16.h),
            _textField(
              label: 'Giới tính',
              value: controller.citizenIdentityCard?.genderStr ?? '-',
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  TextFormField _textField({String label = '', String value = ''}) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      initialValue: value,
    );
  }
}
