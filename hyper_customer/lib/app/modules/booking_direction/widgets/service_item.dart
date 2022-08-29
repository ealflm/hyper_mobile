import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    Key? key,
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onPressed,
    required this.price,
    required this.priceAfterDiscount,
  }) : super(key: key);

  final String svgAsset;
  final String title;
  final String description;
  final bool isSelected;
  final Function() onPressed;
  final double price;
  final int priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.r),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 14.h,
            ),
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.primary300.withOpacity(0.05),
                    border: Border.all(color: AppColors.primary300),
                    borderRadius: BorderRadius.circular(9.r),
                  )
                : BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgAsset,
                  width: 36.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: subtitle2.copyWith(color: AppColors.softBlack),
                      ),
                      Text(
                        description,
                        style: caption.copyWith(color: AppColors.description),
                      ),
                    ],
                  ),
                ),
                if (priceAfterDiscount == 0)
                  Text(
                    NumberUtils.vnd(price),
                    style: subtitle2.copyWith(color: AppColors.softBlack),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberUtils.vnd(price),
                        style: subtitle2.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.softBlack,
                        ),
                      ),
                      Text(
                        NumberUtils.intToVnd(priceAfterDiscount),
                        style: subtitle1.copyWith(
                          color: AppColors.softBlack,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
