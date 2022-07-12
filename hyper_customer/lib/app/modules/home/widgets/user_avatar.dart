import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColors.gray,
          backgroundImage: const NetworkImage(
              'https://i.pinimg.com/280x280_RS/bb/e1/68/bbe168d17c7e6b40b87cf464015f6b16.jpg'),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào',
              style: body2.copyWith(color: Colors.white),
            ),
            Text(
              'Đào Phương Nam',
              style: subtitle1.copyWith(
                fontWeight: FontWeights.medium,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
