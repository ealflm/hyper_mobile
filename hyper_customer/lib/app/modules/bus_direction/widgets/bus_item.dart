import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/modules/bus_direction/controllers/bus_direction_controller.dart';

class BusItem extends GetView<BusDirectionController> {
  const BusItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: EdgeInsets.only(top: 10.h, left: 18.w, right: 18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35.r,
                width: 35.r,
                decoration: const BoxDecoration(
                  color: AppColors.darkBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_bus_filled,
                  color: AppColors.white,
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
                              text: 'Đi tuyến ',
                              style: subtitle1.copyWith(
                                color: AppColors.softBlack,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'A1 - VinHome Grand Park - Bến xe buýt Phú Quốc',
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
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HyperShape.dot(),
                          HyperShape.dot(),
                          HyperShape.dot(),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Xuống tại trạm ',
                              style: subtitle1.copyWith(
                                color: AppColors.softBlack,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Trạm số 7',
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
                      '125 m',
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
