import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/data/models/activity_model.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Orders? model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.ORDER_DETAIL, arguments: {'order': model});
        },
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((model?.serviceTypeName ?? '').contains('Đi xe buýt'))
                _busing()
              else if ((model?.serviceTypeName ?? '').contains('Thuê xe'))
                _renting()
              else if ((model?.serviceTypeName ?? '').contains('Đặt xe'))
                _booking()
              else if ((model?.serviceTypeName ?? '').contains('Nạp tiền'))
                _topUp()
              else if ((model?.serviceTypeName ?? '')
                  .contains('Mua gói dịch vụ'))
                _package()
              else
                _default(),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model?.serviceTypeName}',
                            style: body2.copyWith(
                              color: AppColors.softBlack,
                              fontSize: 14.r,
                            ),
                          ),
                          Text(
                            DateTimeUtils.dateTimeToString(model?.createdDate),
                            style: body2.copyWith(
                              color: AppColors.gray,
                              fontSize: 14.r,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            NumberUtils.vnd(model?.totalPrice),
                            style: subtitle2.copyWith(
                              color: AppColors.softBlack,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ],
                      ),
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

  Container _busing() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gray,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(300.r),
            child: SvgPicture.asset(AppAssets.busing),
          ),
          Center(
            child: SvgPicture.asset(
              AppAssets.busingIcon,
              color: AppColors.white,
              width: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Container _renting() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gray,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(300.r),
            child: SvgPicture.asset(AppAssets.renting),
          ),
          Center(
            child: SvgPicture.asset(
              AppAssets.rentingIcon,
              color: AppColors.white,
              width: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Container _booking() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gray,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(300.r),
            child: SvgPicture.asset(AppAssets.booking),
          ),
          Center(
            child: SvgPicture.asset(
              AppAssets.bookingIcon,
              color: AppColors.white,
              width: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Container _topUp() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary400,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              AppAssets.up,
              color: AppColors.white,
              width: 26.r,
            ),
          ),
        ],
      ),
    );
  }

  Container _package() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue,
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              AntIcons.giftFilled,
              size: 26.r,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _default() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.indicator,
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.description,
              size: 26.r,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
