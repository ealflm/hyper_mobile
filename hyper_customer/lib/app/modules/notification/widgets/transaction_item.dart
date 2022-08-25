import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/data/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Notification? model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((model?.title ?? '').contains('đi xe buýt'))
                _busing()
              else if ((model?.title ?? '').contains('thuê xe'))
                _renting()
              else if ((model?.title ?? '').contains('đặt xe'))
                _booking()
              else if ((model?.title ?? '').contains('MoMo'))
                _moMo()
              else if ((model?.title ?? '').contains('Paypal'))
                _payPal()
              else if ((model?.title ?? '').contains('trả tiền dư'))
                _refund()
              else if ((model?.title ?? '').contains('Mua gói dịch vụ'))
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
                            '${model?.title}',
                            style: subtitle2.copyWith(
                              color: AppColors.softBlack,
                              fontSize: 14.r,
                            ),
                          ),
                          Text(
                            model?.message ?? '',
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
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Container _refund() {
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
            child: SvgPicture.asset(
              AppAssets.refund,
              color: AppColors.white,
              width: 26.r,
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

  Container _payPal() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.line,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              AppAssets.paypal,
              width: 26.r,
            ),
          ),
        ],
      ),
    );
  }

  Container _moMo() {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.otp,
      ),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              AppAssets.momo,
              width: 26.r,
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
              Icons.paid,
              size: 26.r,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
