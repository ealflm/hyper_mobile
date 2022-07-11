import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

abstract class HyperDialog {
  static void show(
      {String title = '', String content = '', String buttonText = ''}) {
    Get.dialog(
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
          TextButton(
            child: Text(
              buttonText,
              style: body2.copyWith(
                color: AppColors.primary400,
              ),
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
