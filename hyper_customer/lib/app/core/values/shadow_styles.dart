import 'package:flutter/material.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';

abstract class ShadowStyles {
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

  static List<BoxShadow> high = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
      color: AppColors.black.withOpacity(0.2),
    ),
  ];

  static List<BoxShadow> bottom = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
      color: AppColors.primary400.withOpacity(0.4),
    ),
  ];

  static List<BoxShadow> service = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 10,
      spreadRadius: 0,
      color: AppColors.black.withOpacity(0.05),
    ),
  ];

  static List<BoxShadow> mapSearch = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 2,
      spreadRadius: 0,
      color: AppColors.black.withOpacity(0.2),
    ),
  ];
}
