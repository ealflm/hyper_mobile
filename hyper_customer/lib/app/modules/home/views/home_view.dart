import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/home/widgets/color_button.dart';
import 'package:hyper_customer/app/modules/home/widgets/show_wallet.dart';
import 'package:hyper_customer/app/modules/home/widgets/user_avatar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: controller.headerState.height,
                  child: SvgPicture.asset(
                    AppAssets.homeBg,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 18.w, top: 11.h, right: 18.w),
                    child: Column(
                      children: [
                        _header(),
                        Column(
                          children: [
                            SizedBox(
                              height: 18.h,
                            ),
                            _wallet(),
                            SizedBox(
                              height: 36.h,
                            ),
                          ],
                        ),
                        SizeTransition(
                          sizeFactor: controller.animation,
                          child: Container(
                            color: Colors.red,
                            height: 100,
                          ),
                        ),
                        Container(
                          color: Colors.blue,
                          height: 100,
                        ),
                      ],
                    ),
                    // AnimatedList(
                    //   key: controller.contentKey,
                    //   primary: false,
                    //   shrinkWrap: true,
                    //   initialItemCount: 4,
                    //   itemBuilder: (context, index, animation) {
                    //     return SizeTransition(
                    //       sizeFactor: animation,
                    //       child: content[index],
                    //     );
                    //   },
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _wallet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: ShadowStyle.surface,
      ),
      width: 324.w,
      height: 104.h,
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 14.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Số dư', style: body2.copyWith(color: AppColors.floatLabel)),
          Text(
            '932,561 VNĐ',
            style: h6.copyWith(color: AppColors.softBlack),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              ColorButton(
                'Nạp tiền',
                onPressed: () {
                  debugPrint('Pressed');
                },
                icon: Icons.payments,
              ),
              SizedBox(
                width: 10.w,
              ),
              ColorButton(
                'Giao dịch',
                onPressed: () => {},
                icon: Icons.summarize_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _header() {
    return Row(
      children: [
        const Expanded(
          child: UserAvatar(),
        ),
        ShowWallet(
          onPressed: () {
            controller.toggleHeader();
          },
          state: controller.headerState.isToggle,
        ),
        SizedBox(
          height: 36.r,
          width: 36.r,
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.white,
            size: 24.r,
          ),
        ),
      ],
    );
  }
}
