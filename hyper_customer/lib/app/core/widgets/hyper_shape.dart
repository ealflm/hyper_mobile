import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';

class HyperShape {
  static Container startCircle() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 6, color: AppColors.blue),
      ),
    );
  }

  static Container dot() {
    return Container(
      width: 3.r,
      height: 3.r,
      decoration: BoxDecoration(
        color: AppColors.indicator,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  static Container endCircle() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.blue,
        border: Border.all(
          width: 6,
          color: AppColors.fadeBlue,
        ),
      ),
    );
  }
}
