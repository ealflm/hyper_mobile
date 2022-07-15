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
          CircleAvatar(
            radius: 48.r,
            backgroundColor: AppColors.gray,
            backgroundImage: const NetworkImage(
                'https://i.pinimg.com/280x280_RS/bb/e1/68/bbe168d17c7e6b40b87cf464015f6b16.jpg'),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Đào Phương Nam',
            style: h6.copyWith(
              color: AppColors.white,
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
