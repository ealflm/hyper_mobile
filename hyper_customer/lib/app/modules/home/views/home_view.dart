import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/scroll_behavior.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/home/widgets/color_button.dart';
import 'package:hyper_customer/app/modules/home/widgets/service_container.dart';
import 'package:hyper_customer/app/modules/home/widgets/show_wallet.dart';
import 'package:hyper_customer/app/modules/home/widgets/user_avatar.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return StatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(
              () => Stack(
                children: [
                  _headerBackground(),
                  ScrollConfiguration(
                    behavior: NoneScrollBehavior(),
                    child: SafeArea(
                      child: SizedBox(
                        height: 1.sh -
                            statusBarHeight -
                            AppValues.bottomAppBarHeight,
                        child: SmartRefresher(
                          controller: refreshController,
                          onRefresh: () async {
                            await Future.delayed(const Duration(seconds: 1));
                            refreshController.refreshCompleted();
                          },
                          header: WaterDropMaterialHeader(
                            distance: 50.h,
                            backgroundColor: AppColors.hardBlue,
                          ),
                          child: ListView(
                            children: [
                              _header(statusBarHeight),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 18.w, top: 18.h, right: 18.w),
                                child: Column(
                                  children: [
                                    _service(),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    _packageBanner(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Column _packageBanner() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(9.r),
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
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              size: 8.w,
              color: AppColors.indicator,
            ),
            SizedBox(
              width: 16.w,
            ),
            Icon(
              Icons.circle_outlined,
              size: 8.w,
              color: AppColors.indicator,
            ),
          ],
        ),
      ],
    );
  }

  Column _service() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ServiceContainer(
              onPressed: () {},
              title: 'Đặt xe',
              backgroundAsset: AppAssets.booking,
              iconAsset: AppAssets.bookingIcon,
              color: AppColors.booking.withOpacity(0.4),
            ),
            SizedBox(
              width: 18.w,
            ),
            ServiceContainer(
              onPressed: () {},
              title: 'Thuê xe',
              backgroundAsset: AppAssets.renting,
              iconAsset: AppAssets.rentingIcon,
              color: AppColors.renting.withOpacity(0.4),
            ),
            SizedBox(
              width: 18.w,
            ),
            ServiceContainer(
              onPressed: () {},
              title: 'Đi xe buýt',
              backgroundAsset: AppAssets.busing,
              iconAsset: AppAssets.busingIcon,
              color: AppColors.busing.withOpacity(0.4),
            ),
          ],
        ),
      ],
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
                icon: Icons.payments_outlined,
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

  Row _appBar() {
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
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.NOTIFICATION);
          },
          child: SizedBox(
            height: 36.r,
            width: 36.r,
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
              size: 24.r,
            ),
          ),
        ),
      ],
    );
  }

  AnimatedContainer _headerBackground() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecorations.header(),
      height: controller.headerState.height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.r),
          bottomRight: Radius.circular(5.r),
        ),
        child: SvgPicture.asset(
          AppAssets.homeBg,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> _header(double statusBarHeight) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: controller.headerState.height - statusBarHeight,
        end: controller.headerState.height - statusBarHeight,
      ),
      duration: const Duration(milliseconds: 250),
      builder: (
        BuildContext context,
        double height,
        Widget? child,
      ) {
        return Container(
          padding: EdgeInsets.only(left: 18.w, top: 11.h, right: 18.w),
          height: height,
          child: Column(
            children: [
              _appBar(),
              !controller.headerState.isToggle
                  ? Column(
                      children: [
                        SizedBox(
                          height: 18.h,
                        ),
                        _wallet(),
                        SizedBox(
                          height: 18.h,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
