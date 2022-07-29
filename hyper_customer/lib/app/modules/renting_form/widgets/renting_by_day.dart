import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/renting_form/controllers/renting_day_count_controller.dart';

class RentingByDay extends GetWidget<RentingDayCountController> {
  const RentingByDay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RentingDayCountController>(
      builder: (_) {
        return Column(
          children: [
            Column(
              children: [
                if (controller.isShowHint.value)
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
                          'Số ngày thuê quy định nằm trong khoảng từ 1 đến 14 ngày',
                          style: body2.copyWith(
                            color: AppColors.description,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Số ngày',
                  style: subtitle1.copyWith(
                    fontWeight: FontWeights.regular,
                    color: AppColors.lightBlack,
                  ),
                ),
                Row(
                  children: [
                    _circleButton(
                      () {
                        controller.decreaseDay();
                      },
                      icon: Icons.remove,
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    SizedBox(
                      width: 30.w,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                        textAlign: TextAlign.center,
                        style: h6.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeights.regular,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: controller.textInputController,
                        onChanged: controller.onInputChange,
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    _circleButton(
                      () {
                        controller.increaseDay();
                      },
                      icon: Icons.add,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: AppColors.line,
            ),
            _dateDetailItem(
              'Thời gian thuê',
              controller.dateStartByDay(),
            ),
            const Divider(
              color: AppColors.line,
            ),
            _dateDetailItem(
              'Thời gian trả',
              controller.dateEndByDay(),
            ),
            const Divider(
              color: AppColors.line,
            ),
            SizedBox(
              height: 20.h,
            ),
            // Row(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Thành tiền',
            //           style: subtitle1.copyWith(
            //             fontWeight: FontWeights.regular,
            //             color: AppColors.lightBlack,
            //           ),
            //         ),
            //         SizedBox(
            //           height: 10.h,
            //         ),
            //         Text(
            //           controller.total,
            //           style: subtitle1.copyWith(
            //             color: AppColors.softBlack,
            //             fontWeight: FontWeights.medium,
            //             fontSize: 18.sp,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // )
          ],
        );
      },
    );
  }

  Row _dateDetailItem(String key, String value) {
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

  ElevatedButton _circleButton(Function() onPressed, {required IconData icon}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: AppColors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0),
        minimumSize: Size(35.r, 35.r),
      ),
      child: SizedBox(
        height: 35.r,
        width: 35.r,
        child: Icon(
          icon,
          size: 18.r,
          // color: AppColors.gray,
          color: AppColors.softBlack,
        ),
      ),
    );
  }
}
