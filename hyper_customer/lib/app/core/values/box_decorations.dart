import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';

abstract class BoxDecorations {
  static BoxDecoration top() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
      boxShadow: ShadowStyle.top,
    );
  }

  static BoxDecoration header() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5.r),
        bottomRight: Radius.circular(5.r),
      ),
      boxShadow: ShadowStyle.bottom,
    );
  }

  static BoxDecoration service() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(9.r),
      boxShadow: ShadowStyle.service,
    );
  }
}
