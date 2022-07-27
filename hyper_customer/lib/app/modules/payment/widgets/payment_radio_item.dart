import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class PaymentRadioItem extends StatelessWidget {
  const PaymentRadioItem({
    Key? key,
    required this.state,
    required this.onPressed,
    required this.svgAsset,
    required this.title,
    required this.description,
  }) : super(key: key);

  final Function() onPressed;
  final bool state;
  final String svgAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: state
          ? ButtonStyles.paymentRadio()
          : ButtonStyles.paymentRadioNotSelected(),
      child: Row(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 36.w,
            height: 36.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: subtitle2.copyWith(color: AppColors.softBlack),
                ),
                Text(
                  description,
                  style: caption.copyWith(
                    color: AppColors.description,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: state
                  ? Border.all(width: 7, color: AppColors.primary400)
                  : Border.all(width: 2, color: AppColors.gray),
            ),
          ),
        ],
      ),
    );
  }
}
