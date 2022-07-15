import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class ServiceContainer extends StatelessWidget {
  const ServiceContainer({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.iconAsset,
    required this.backgroundAsset,
    required this.color,
  }) : super(key: key);

  final Function()? onPressed;
  final String iconAsset;
  final String backgroundAsset;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 0,
                color: color,
              ),
            ],
          ),
          width: 95.w,
          height: 95.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: SvgPicture.asset(
              backgroundAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 95.w,
          height: 95.w,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: SvgPicture.asset(
                      iconAsset,
                      fit: BoxFit.cover,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: subtitle2.copyWith(color: AppColors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.r),
          child: InkWell(
            onTap: onPressed,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
              ),
              width: 95.w,
              height: 95.w,
            ),
          ),
        ),
      ],
    );
  }
}
