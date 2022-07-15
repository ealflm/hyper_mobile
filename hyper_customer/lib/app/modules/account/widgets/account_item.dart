import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.child,
    this.onPress,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Color color;
  final Widget? child;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () {},
      child: Ink(
        height: 44.h,
        child: Row(
          children: [
            CircleAvatar(
              radius: 17.r,
              backgroundColor: color,
              child: Icon(
                icon,
                size: 20.r,
                color: AppColors.white,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: subtitle1.copyWith(color: AppColors.softBlack),
                    ),
                  ),
                  child ?? Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
