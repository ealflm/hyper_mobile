import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/bus_direction/controllers/bus_direction_controller.dart';

class WalkItem extends GetView<BusDirectionController> {
  const WalkItem({
    Key? key,
    required this.destination,
    required this.distance,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String destination;
  final int distance;
  final bool isSelected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.otp : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          padding: EdgeInsets.only(top: 10.h, left: 18.w, right: 18.w),
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
                  Icons.directions_walk,
                  color: AppColors.softBlack,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Đi bộ đến ',
                              style: subtitle1.copyWith(
                                color: AppColors.softBlack,
                              ),
                              children: [
                                TextSpan(
                                  text: destination,
                                  style: subtitle1.copyWith(
                                    color: AppColors.softBlack,
                                    fontWeight: FontWeights.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      NumberUtils.distance(distance),
                      style: body2.copyWith(color: AppColors.description),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divider(
                      color: AppColors.line,
                      height: 1,
                    )
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
