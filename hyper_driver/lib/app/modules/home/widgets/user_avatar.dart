import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';

class UserAvatar extends GetView<HomeController> {
  const UserAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: Size.fromRadius(18.r), // Image radius
            child: Obx(
              () => CachedNetworkImage(
                fadeInDuration: const Duration(),
                fadeOutDuration: const Duration(),
                placeholder: (context, url) {
                  return controller.user.value?.gender == 'False'
                      ? SvgPicture.asset(AppAssets.female)
                      : SvgPicture.asset(AppAssets.male);
                },
                imageUrl: controller.user.value?.url ?? '-',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return controller.user.value?.gender == 'False'
                      ? SvgPicture.asset(AppAssets.female)
                      : SvgPicture.asset(AppAssets.male);
                },
              ),
            ),
          ),
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
            Obx(
              () => Text(
                controller.user.value?.fullName ?? '-',
                style: subtitle1.copyWith(
                  fontWeight: FontWeights.medium,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
