import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/data/models/activity_model.dart';
import 'package:hyper_customer/app/modules/scan/models/scan_mode.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class BusingItem extends StatelessWidget {
  const BusingItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CustomerTrips? model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.SCAN,
            arguments: {
              'scanMode': ScanMode.returnVehicle,
              'customerTrips': model,
            },
          );
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
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          Text(
                            DateTimeUtils.dateTimeToString(model?.createdDate),
                            style: body2.copyWith(
                              color: AppColors.gray,
                              fontSize: 14.r,
                            ),
                          ),
                          if (model?.status == 6) _chip('Hoàn thành')
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${model?.vehicleName}',
                                style: subtitle2.copyWith(
                                  color: AppColors.softBlack,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                              Text(
                                '${model?.licensePlates}',
                                style: subtitle2.copyWith(
                                  color: AppColors.description,
                                  fontWeight: FontWeights.regular,
                                ),
                              ),
                            ],
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

  Widget _chip(String text) {
    Color color = AppColors.yellow;
    if (text == 'Hoàn thành') {
      color = AppColors.primary400;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Text(
        text,
        style: caption.copyWith(
          color: AppColors.white,
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
