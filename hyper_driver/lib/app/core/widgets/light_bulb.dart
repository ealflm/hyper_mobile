import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class LightBulb extends StatelessWidget {
  const LightBulb({
    Key? key,
    this.message = '',
    this.child,
    this.isCenter = false,
  }) : super(key: key);

  final String message;
  final Widget? child;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.r,
          height: 24.r,
          padding: EdgeInsets.all(3.r),
          decoration: const BoxDecoration(
            color: AppColors.primary400,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            AppAssets.lightBulb,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: child != null
              ? child ?? Container()
              : Text(
                  message,
                  style: body2.copyWith(
                    color: AppColors.description,
                  ),
                ),
        ),
      ],
    );
  }
}
