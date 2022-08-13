import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:lottie/lottie.dart';

abstract class HyperDialog {
  static bool isOpen = false;
  static Future<void> show({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    if (isOpen) {
      Get.back();
    }
    isOpen = true;
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        content: Text(
          content,
          style: subtitle1.copyWith(color: AppColors.description),
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then(
      (value) {
        isOpen = false;
      },
    );
  }

  static Future<void> showLoading({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    if (isOpen) {
      Get.back();
    }
    isOpen = true;
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        content: Lottie.asset(
          AppAnimationAssets.earthLoadingClean,
          height: 100.r,
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then(
      (value) {
        isOpen = false;
      },
    );
  }

  static Future<void> showSuccess({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    if (isOpen) {
      Get.back();
    }
    isOpen = true;
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        // contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        content: Text(
          'Giao dịch thành công',
          style: subtitle1.copyWith(
            fontWeight: FontWeights.medium,
            color: AppColors.lightBlack,
          ),
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then(
      (value) {
        isOpen = false;
      },
    );
  }

  static Future<void> showFail({
    String title = '',
    String content = '',
    String primaryButtonText = '',
    String? secondaryButtonText,
    bool barrierDismissible = true,
    Function()? primaryOnPressed,
    Function()? secondaryOnPressed,
  }) async {
    if (isOpen) {
      Get.back();
    }
    isOpen = true;
    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: subtitle1.copyWith(color: AppColors.softBlack),
        ),
        // contentPadding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Giao dịch thất bại',
              style: subtitle1.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              'Đã có lỗi xảy ra trong quá trình giao dịch',
              style: body2.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
          ],
        ),
        actions: [
          if (secondaryButtonText != null && secondaryButtonText.isNotEmpty)
            TextButton(
              child: Text(
                secondaryButtonText,
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
              onPressed: () => secondaryOnPressed != null
                  ? secondaryOnPressed()
                  : Get.back(),
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () =>
                primaryOnPressed != null ? primaryOnPressed() : Get.back(),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then(
      (value) {
        isOpen = false;
      },
    );
  }
}
