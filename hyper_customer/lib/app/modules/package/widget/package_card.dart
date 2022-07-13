import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 130.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              width: 324.w,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(9.r),
                    bottomRight: Radius.circular(9.r),
                  ),
                  boxShadow: ShadowStyles.surface,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 18.w,
                    top: 40.h,
                    right: 18.w,
                    bottom: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gói siêu VIP',
                        style:
                            subtitle1.copyWith(fontWeight: FontWeights.medium),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 16.r,
                            color: AppColors.lightBlack,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          const Text('24:00'),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Đi xe buýt thả ga với 30 Km hoặc 5 lần quẹt thẻ. Giảm 10% giá đặt xe.',
                        style: body2.copyWith(color: AppColors.softBlack),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giá:',
                                style: body2.copyWith(
                                    color: AppColors.description),
                              ),
                              Text('40.000đ',
                                  style: subtitle1.copyWith(
                                    fontWeight: FontWeights.medium,
                                  )),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyles.primarySmall(),
                            onPressed: () {},
                            child: HyperButton.child(
                              status: false,
                              child: Text('Áp dụng', style: button),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(9.r),
              boxShadow: ShadowStyles.high,
            ),
            width: 324.w,
            height: 160.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.r),
              child: SvgPicture.asset(
                AppAssets.packageBanner,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
