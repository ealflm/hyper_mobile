import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/feedback_driver/widgets/starts.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

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
                              if (controller.backToHome) {
                                Get.offAllNamed(Routes.MAIN);
                              } else {
                                Get.back();
                              }
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
                  _avatarCircle(),
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
                    height: 30.h,
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
                              Obx(
                                () => SizedBox(
                                  width: 200.w,
                                  child: ElevatedButton(
                                    style: ButtonStyles.primaryMedium(),
                                    onPressed: controller.isLoading
                                        ? null
                                        : () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            controller.submit();
                                          },
                                    child: HyperButton.child(
                                      status: controller.isLoading,
                                      child: Text(
                                        'Gửi đánh giá',
                                        style: buttonBold,
                                      ),
                                    ),
                                  ),
                                ),
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
            onChanged: (String text) {
              controller.changeFeedBackMessage(text);
            },
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
              labelText: 'Để lại góp ý',
              labelStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
              hintStyle: subtitle1.copyWith(
                color: AppColors.description,
              ),
            ),
            onChanged: (String text) {
              controller.changeFeedBackMessage(text);
            },
          ),
        ),
      ],
    );
  }

  Widget _iconFeedBack(String asset, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.r),
      child: Obx(
        () => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.feedBackEmotion.value == title) {
                controller.changeFeedBackEmotion('');
              } else {
                controller.changeFeedBackEmotion(title);
              }
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Ink(
              color: controller.feedBackEmotion.value == title
                  ? AppColors.otp
                  : null,
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
      ),
    );
  }

  Widget _avatarCircle() {
    return Obx(
      () => _oval(
        controller.photoUrl.value ?? '',
        controller.gender.value != 'True',
      ),
    );
  }

  ClipOval _oval(String url, bool gender) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(30.r), // Image radius
        child: CachedNetworkImage(
          fadeInDuration: const Duration(),
          fadeOutDuration: const Duration(),
          placeholder: (context, url) {
            return gender
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return gender
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
        ),
      ),
    );
  }
}
