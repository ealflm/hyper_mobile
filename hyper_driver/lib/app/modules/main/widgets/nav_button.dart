import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconOutlined,
    required this.onPressed,
    required this.state,
  }) : super(key: key);

  final Function() onPressed;
  final String title;
  final IconData icon;
  final IconData iconOutlined;
  final bool state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.w,
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.r,
              width: 26.r,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  state ? icon : iconOutlined,
                  size: 26.r,
                  color: state ? AppColors.primary400 : AppColors.gray,
                ),
              ),
            ),
            Text(
              title,
              style: state
                  ? overline.copyWith(fontWeight: FontWeights.medium)
                  : overline.copyWith(color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}
