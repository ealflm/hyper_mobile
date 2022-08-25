import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PackageStatusItem extends StatelessWidget {
  const PackageStatusItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.total,
    required this.unit,
    required this.animation,
    this.percent,
    this.isDisable = false,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final int value;
  final int total;
  final String unit;
  final bool animation;
  final int? percent;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    if (total == 0) return Container();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 16.h,
      ),
      width: 312.w,
      decoration: BoxDecorations.service(),
      child: Column(
        children: [
          LinearPercentIndicator(
            padding: EdgeInsets.all(0.r),
            animation: true,
            lineHeight: 5.h,
            animationDuration: animation ? 500 : 0,
            percent: min(value, total) / total,
            barRadius: Radius.circular(50.r),
            progressColor:
                !isDisable ? AppColors.primary400 : AppColors.description,
            backgroundColor: AppColors.otp,
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: !isDisable ? AppColors.softBlack : AppColors.description,
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: subtitle2.copyWith(
                      color: !isDisable
                          ? AppColors.softBlack
                          : AppColors.description,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${min(value, total)}',
                        style: h6.copyWith(
                          color: !isDisable
                              ? AppColors.softBlack
                              : AppColors.description,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        '/$total $unit',
                        style: body2.copyWith(
                          color: !isDisable
                              ? AppColors.lightBlack
                              : AppColors.description,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (percent != null)
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Giảm $percent%',
                      style: body2.copyWith(
                        color: !isDisable
                            ? AppColors.softBlack
                            : AppColors.description,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
