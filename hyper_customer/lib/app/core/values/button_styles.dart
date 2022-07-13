import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

abstract class ButtonStyles {
  static ButtonStyle primary() {
    return ElevatedButton.styleFrom(
      shadowColor: AppColors.primary400,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      textStyle: button.copyWith(fontWeight: FontWeight.bold),
    );
  }

  static ButtonStyle primarySmall() {
    return ElevatedButton.styleFrom(
      shadowColor: AppColors.primary400,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      textStyle: button.copyWith(fontWeight: FontWeight.bold),
    );
  }

  static ButtonStyle textCircle() {
    return TextButton.styleFrom(
      shape: const CircleBorder(),
      padding: EdgeInsets.all(18.r),
    );
  }

  static ButtonStyle fingerPrint() {
    return ElevatedButton.styleFrom(
      shadowColor: AppColors.primary400,
      shape: const CircleBorder(),
    );
  }
}
