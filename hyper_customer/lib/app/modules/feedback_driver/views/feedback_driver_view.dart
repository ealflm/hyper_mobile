import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/feedback_driver/widgets/starts.dart';

import '../controllers/feedback_driver_controller.dart';

class FeedbackDriverView extends GetView<FeedbackDriverController> {
  const FeedbackDriverView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Unfocus(
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.w, top: 10.h),
                          child: ElevatedButton(
                            onPressed: () async {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: AppColors.white,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.all(0),
                              minimumSize: Size(40.r, 40.r),
                            ),
                            child: SizedBox(
                              height: 40.r,
                              width: 40.r,
                              child: Icon(
                                Icons.close,
                                size: 18.r,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  _avatar(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: Text(
                      'Bạn thấy chuyến đi như thế nào?',
                      style: h6.copyWith(
                        color: AppColors.softBlack,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Stars(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () {
                      Widget result = Container();
                      if (controller.feedBackPoint.value != 0) {
                        if (controller.feedBackPoint.value <= 2) {
                          result = _bad();
                        } else if (controller.feedBackPoint.value <= 5) {
                          result = _good();
                        }
                      }
                      return result;
                    },
                  ),
                  Obx(
                    () => controller.feedBackPoint.value != 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              ElevatedButton(
                                style: ButtonStyles.primaryMedium(),
                                onPressed: () {},
                                child: Text('Gửi đánh giá', style: button),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _good() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Text(
            'Bạn hài lòng về cuốc xe chứ? Hãy cho tài xế biết ý kiến của bạn.',
            style: body1.copyWith(
              color: AppColors.softBlack,
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              _iconFeedBack(AppAssets.friendly, 'Tài xế rất thân thiện'),
              SizedBox(
                width: 10.w,
              ),
              _iconFeedBack(AppAssets.enthusiasm, 'Tài xế rất nhiệt tình'),
              SizedBox(
                width: 10.w,
              ),
              _iconFeedBack(AppAssets.impressive, 'Xe rất ấn tượng'),
              SizedBox(
                width: 10.w,
              ),
              _iconFeedBack(AppAssets.goodService, 'Dịch vụ tuyệt hảo'),
              SizedBox(
                width: 20.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 11.h,
              ),
              labelText: 'Để lại lời khen',
              labelStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
              hintStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _bad() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Text(
            'Bạn hài lòng về cuốc xe chứ? Hãy cho tài xế biết ý kiến của bạn.',
            style: body1.copyWith(
              color: AppColors.softBlack,
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              _iconFeedBack(AppAssets.notFriendly, 'Tài xế không thân thiện'),
              SizedBox(
                width: 10.w,
              ),
              _iconFeedBack(AppAssets.badService, 'Dịch vụ không tốt'),
              SizedBox(
                width: 10.w,
              ),
              _iconFeedBack(AppAssets.dangerous, 'Chạy xe không an toàn'),
              SizedBox(
                width: 20.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 11.h,
              ),
              labelText: 'Để lại lời khen',
              labelStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
              hintStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconFeedBack(String asset, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.r),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: SvgPicture.asset(
                    asset,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  title,
                  style: body2.copyWith(
                    color: AppColors.softBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ClipOval _avatar() {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(30.r), // Image radius
        child:
            //  Obx(
            //   () =>
            CachedNetworkImage(
          fadeInDuration: const Duration(),
          fadeOutDuration: const Duration(),
          placeholder: (context, url) {
            return true
                // return controller.user.value?.gender == 'False'
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
          // imageUrl: controller.user.value?.url ?? '-',
          imageUrl:
              'https://scontent-hkt1-2.xx.fbcdn.net/v/t1.6435-9/169527907_3015381458750007_4745031971809477507_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=qDNSnADBb-gAX-BP0_w&tn=UDyz_9o-7VgYgtCy&_nc_ht=scontent-hkt1-2.xx&oh=00_AT-57A_wWkHnDaKt3Bcl3oXFeFkmsCF08gr-MxzxA7jwHA&oe=63291479',
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return true
                // return controller.user.value?.gender == 'False'
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
        ),
      ),
    );
  }
}
