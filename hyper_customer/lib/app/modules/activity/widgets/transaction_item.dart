import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.gray,
            backgroundImage: const NetworkImage(
              'https://i.pinimg.com/280x280_RS/bb/e1/68/bbe168d17c7e6b40b87cf464015f6b16.jpg',
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Happy coding!',
                  style: subtitle2.copyWith(
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  'Understanding color theory: the color wheel and finding complementary colors',
                  style: caption.copyWith(
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  '21:00',
                  style: caption.copyWith(
                    color: AppColors.gray,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
