import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/button_styles.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/light_bulb.dart';
import 'package:hyper_driver/app/modules/register/controllers/register_controller.dart';

class ScanPrepare extends GetView<RegisterController> {
  const ScanPrepare({
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
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyles.primary(),
              onPressed: () {
                controller.changeStep(2);
              },
              child: Text(
                'Tiếp tục',
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
              'Vui lòng chuẩn bị',
              style: h5.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              'Bản gốc CCCD',
              style: h5.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            const LightBulb(
              message: 'Bạn cần đủ 16 tuổi để mở tài khoản Hyper',
            ),
          ],
        ),
      ),
    );
  }
}
