import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    Key? key,
    this.title = '',
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final String title;
  final Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          color: AppColors.white,
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  top: 10.h,
                ),
                child: Container(
                  height: 35.r,
                  width: 35.r,
                  decoration: const BoxDecoration(
                    color: AppColors.softGray,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.softBlack,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: subtitle1.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
