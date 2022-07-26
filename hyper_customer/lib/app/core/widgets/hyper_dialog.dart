import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

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
}
