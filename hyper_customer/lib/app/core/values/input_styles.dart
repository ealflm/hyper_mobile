import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

abstract class InputStyles {
  static InputDecoration roundBorder(
      {Widget? prefixIcon, String labelText = "", String hintText = ""}) {
    return InputDecoration(
      errorStyle: caption,
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      labelText: labelText,
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 11.w),
              child: prefixIcon,
            )
          : null,
    );
  }

  static InputDecoration softBorder({
    String labelText = "",
    String hintText = "",
    bool state = false,
    Function()? suffixAction,
  }) {
    return InputDecoration(
      errorStyle: caption,
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      labelText: labelText,
      hintText: hintText,
      suffixIcon: state
          ? TextButton(
              onPressed: suffixAction,
              child: const Icon(
                Icons.cancel,
                color: AppColors.softBlack,
              ),
            )
          : null,
      suffixText: 'VNĐ',
      floatingLabelStyle:
          MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.error)
            ? Get.theme.errorColor
            : AppColors.softBlack;
        return TextStyle(color: color);
      }),
    );
  }

  static InputDecoration mapSearch(
      {Widget? prefixIcon, String labelText = "", String hintText = ""}) {
    return InputDecoration(
      errorStyle: caption,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      labelText: labelText,
      hintText: hintText,
      labelStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      hintStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: prefixIcon,
            )
          : null,
    );
  }

  static InputDecoration mapSearchOutlined(
      {Widget? prefixIcon, String labelText = "", String hintText = ""}) {
    return InputDecoration(
      errorStyle: caption,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      labelText: labelText,
      hintText: hintText,
      labelStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      hintStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: prefixIcon,
            )
          : null,
    );
  }

  static InputDecoration map(
      {Widget? prefixIcon, String labelText = "", String hintText = ""}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: prefixIcon,
            )
          : null,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.blue,
          width: 2,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: subtitle1.copyWith(
        color: AppColors.description,
        fontWeight: FontWeights.medium,
      ),
      hintStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
    );
  }
}
