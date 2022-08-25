import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/package_model.dart';
import 'package:hyper_customer/app/modules/package/controllers/package_controller.dart';
import 'package:shimmer/shimmer.dart';

class PackageCard extends GetView<PackageController> {
  const PackageCard(
    this.model, {
    Key? key,
  }) : super(key: key);

  final Package model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 130.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              width: 324.w,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(9.r),
                    bottomRight: Radius.circular(9.r),
                  ),
                  boxShadow: ShadowStyles.surface,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 18.w,
                    top: 40.h,
                    right: 18.w,
                    bottom: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style:
                            subtitle1.copyWith(fontWeight: FontWeights.medium),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 16.r,
                            color: AppColors.lightBlack,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            '${model.duration ?? 0} ngày',
                            style: body1.copyWith(color: AppColors.lightBlack),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '${model.description}',
                        style: body2.copyWith(color: AppColors.softBlack),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giá:',
                                style: body2.copyWith(
                                    color: AppColors.description),
                              ),
                              Text(NumberUtils.intToVnd(model.price),
                                  style: subtitle1.copyWith(
                                    fontWeight: FontWeights.medium,
                                  )),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyles.primarySmall(),
                            onPressed: () {
                              HyperDialog.show(
                                title: 'Xác nhận',
                                content: 'Bạn có chắc chắn muốn mua gói này?',
                                primaryButtonText: 'Đồng ý',
                                primaryOnPressed: () async {
                                  await controller.buyPackage(model.id ?? '');
                                  controller.fetchPackages();
                                  controller.getCurrentPackage();
                                },
                                secondaryButtonText: 'Huỷ',
                                secondaryOnPressed: () {
                                  Get.back();
                                },
                              );
                            },
                            child: HyperButton.child(
                              status: false,
                              child: Text('Áp dụng', style: button),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(9.r),
              boxShadow: ShadowStyles.high,
            ),
            width: 324.w,
            height: 160.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.r),
              child: CachedNetworkImage(
                fadeInDuration: const Duration(),
                fadeOutDuration: const Duration(),
                imageUrl:
                    AppValues.photoBaseUrl + (model.photoUrl ?? '').trim(),
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.shimmerBaseColor,
                    highlightColor: AppColors.shimmerHighlightColor,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
