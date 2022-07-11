import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

abstract class HyperButton {
  static Widget? child({required bool status, Widget? child}) {
    return status ? _loading() : child;
  }

  static Widget _loading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 14.h,
          width: 14.h,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.description,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          'Tiếp tục',
          style: button.copyWith(color: AppColors.description),
        ),
      ],
    );
  }
}
