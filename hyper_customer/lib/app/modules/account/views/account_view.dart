import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/account/widgets/account_item.dart';
import 'package:hyper_customer/app/modules/account/widgets/card_item.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                _headerBackground(),
                _header(),
              ],
            ),
            SizedBox(
              height: 1.sh - 212.h - AppValues.bottomAppBarHeight,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 28.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tài khoản',
                          style: body2.copyWith(color: AppColors.gray),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        const AccountItem(
                          icon: Icons.person,
                          text: 'Tài khoản của tôi',
                          color: AppColors.blue,
                        ),
                        const AccountItem(
                          icon: Icons.key,
                          text: 'Đổi mã PIN',
                          color: AppColors.green,
                        ),
                        AccountItem(
                          onPress: () {
                            controller.toggleFingerprint();
                          },
                          icon: Icons.fingerprint,
                          text: 'Đăng nhập với vân tay',
                          color: AppColors.purple,
                          child: IgnorePointer(
                            ignoring: true,
                            child: Obx(
                              () => Switch(
                                activeColor: AppColors.primary400,
                                onChanged: (value) {},
                                value: controller.fingerprintState.value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dịch vụ',
                          style: body2.copyWith(color: AppColors.gray),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => CardItem(
                            onPress: () {
                              controller.toggleCardStatus();
                            },
                            icon: Icons.credit_card,
                            text: 'Trạng thái thẻ',
                            description: controller.cardStatus.value
                                ? 'Đã liên kết'
                                : 'Chưa liên kết',
                            color: AppColors.hardBlue,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Switch(
                                activeColor: AppColors.primary400,
                                onChanged: (value) {},
                                value: controller.cardStatus.value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuỳ chọn',
                          style: body2.copyWith(color: AppColors.gray),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        AccountItem(
                          onPress: () {
                            controller.logout();
                          },
                          icon: Icons.power_settings_new,
                          text: 'Đăng xuất',
                          color: AppColors.orange,
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
    );
  }

  SizedBox _header() {
    return SizedBox(
      height: 212.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(58.r), // Image radius
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
            height: 10.h,
          ),
          Obx(
            () => Text(
              controller.user.value?.fullName ?? '-',
              style: h6.copyWith(
                color: AppColors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _headerBackground() {
    return Container(
      decoration: BoxDecorations.header(),
      width: double.infinity,
      height: 212.h,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.r),
          bottomRight: Radius.circular(5.r),
        ),
        child: SvgPicture.asset(
          AppAssets.accountBg,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
