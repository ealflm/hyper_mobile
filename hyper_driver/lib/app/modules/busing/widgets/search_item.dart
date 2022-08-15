import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';

import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.stationNumber,
    required this.firstStationName,
    required this.price,
    required this.onPressed,
  }) : super(key: key);

  final int stationNumber;
  final String firstStationName;
  final double price;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          color: AppColors.white,
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 18.w,
            right: 18.w,
            top: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đi qua $stationNumber trạm',
                style: subtitle1.copyWith(color: AppColors.description),
              ),
              Text(
                'Đón xe tại trạm: $firstStationName',
                style: subtitle1.copyWith(color: AppColors.description),
              ),
              Row(
                children: [
                  Text(
                    'Giá vé: ',
                    style: subtitle1.copyWith(color: AppColors.description),
                  ),
                  Text(
                    NumberUtils.vnd(price),
                    style: subtitle1.copyWith(
                      color: AppColors.softBlack,
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              const Divider(
                color: AppColors.line,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
