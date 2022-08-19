import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';

import '../../../core/values/app_assets.dart';
import '../../../core/values/text_styles.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Unfocus(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18.r,
            ),
            onPressed: () => Get.back(),
          ),
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.black,
          elevation: 1,
          title: GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              children: [
                _avatar(),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đào Phương Nam",
                      style: subtitle1.copyWith(
                        color: AppColors.softBlack,
                        fontSize: 18.sp,
                        fontWeight: FontWeights.medium,
                      ),
                    ),
                    Text(
                      "69E1-477.18 • Yamaha MXKing",
                      style: subtitle1.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        errorStyle: caption,
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        hintText: 'Nhắn tin',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(Icons.send),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ClipOval _avatar() {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(20.r), // Image radius
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
          imageUrl: 'https://avatars.githubusercontent.com/u/51223583?v=4',
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
