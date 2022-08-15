import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class ShowWallet extends StatelessWidget {
  const ShowWallet({Key? key, required this.state, required this.onPressed})
      : super(key: key);

  final bool state;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 36.h,
        child: state
            ? Row(
                children: [
                  Text(
                    'Hiện ví',
                    style: subtitle2.copyWith(color: AppColors.white),
                  ),
                  Icon(
                    Icons.expand_more,
                    size: 20.r,
                    color: AppColors.white,
                  ),
                ],
              )
            : Row(
                children: [
                  Text(
                    'Ẩn ví',
                    style: subtitle2.copyWith(color: AppColors.white),
                  ),
                  Icon(
                    Icons.expand_less,
                    size: 20.r,
                    color: AppColors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
