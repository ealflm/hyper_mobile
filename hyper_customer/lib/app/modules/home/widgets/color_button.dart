import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class ColorButton extends StatelessWidget {
  const ColorButton(
    this.text, {
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26.h,
      child: Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 6.h,
                horizontal: 10.w,
              ),
              backgroundColor: AppColors.primary500.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16.r,
                  color: AppColors.primary500,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  text,
                  style: caption.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
