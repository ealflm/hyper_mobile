import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/renting_form/controllers/renting_form_controller.dart';

class PaymentDetail extends GetView<RentingFormController> {
  const PaymentDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chi tiết',
                    style: h6.copyWith(
                      color: AppColors.lightBlack,
                      fontWeight: FontWeights.regular,
                    )),
                Text(
                  'Thanh toán',
                  style: h6.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              padding: EdgeInsets.all(3.r),
              decoration: const BoxDecoration(
                color: AppColors.primary400,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.lightBulb,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                'Phí thu hồi xe sẽ được hoàn trả sau khi xe được trả lại đúng thời hạn',
                style: body2.copyWith(
                  color: AppColors.description,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        controller.modeIndex.value == 0
            ? _detailItem(
                'Thuê xe theo ngày',
                '${controller.dayNum} x ${NumberUtils.vnd(controller.vehicleRental?.pricePerDay?.toDouble())}',
              )
            : _detailItem(
                'Thuê xe theo giờ',
                '${controller.hourNum} x ${NumberUtils.vnd(controller.vehicleRental?.pricePerHour?.toDouble())}',
              ),
        SizedBox(
          height: 5.h,
        ),
        _detailItem(
          'Phí thu hồi xe',
          '1 x ${NumberUtils.vnd(AppValues.recallFee)}',
        ),
        const Divider(
          color: AppColors.line,
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tổng tiền',
                  style: subtitle1.copyWith(
                    fontWeight: FontWeights.regular,
                    color: AppColors.lightBlack,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  NumberUtils.vnd(controller.getTotalPrice()),
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row _detailItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: subtitle1.copyWith(
            fontWeight: FontWeights.regular,
            color: AppColors.lightBlack,
          ),
        ),
        Text(
          value,
          style: subtitle1.copyWith(
            color: AppColors.softBlack,
            fontWeight: FontWeights.medium,
          ),
        ),
      ],
    );
  }
}
