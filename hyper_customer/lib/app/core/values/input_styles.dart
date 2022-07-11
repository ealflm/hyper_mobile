import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
}
