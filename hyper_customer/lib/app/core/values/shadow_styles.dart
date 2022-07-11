import 'package:flutter/material.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';

abstract class ShadowStyle {
  static List<BoxShadow> top = [
    BoxShadow(
      offset: const Offset(0, -1),
      blurRadius: 6,
      spreadRadius: 0,
      color: AppColors.black.withOpacity(0.08),
    ),
  ];
  static List<BoxShadow> surface = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 4,
      spreadRadius: 0,
      color: AppColors.black.withOpacity(0.05),
    ),
  ];
}
