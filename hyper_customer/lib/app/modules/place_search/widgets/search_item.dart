import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String description;
  final Function()? onPressed;

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
            top: 12.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35.r,
                width: 35.r,
                decoration: const BoxDecoration(
                  color: AppColors.softGray,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.softBlack,
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
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
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
