import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_search_route_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class SearchRoute extends GetView<BusingSearchRouteController> {
  const SearchRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(9.r),
          bottomRight: Radius.circular(9.r),
        ),
        boxShadow: ShadowStyles.map,
      ),
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        bottom: 18.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchInput(),
          SizedBox(
            height: 10.h,
          ),
          _maxTrips(),
          SizedBox(
            height: 10.h,
          ),
          _action(),
        ],
      ),
    );
  }

  Widget _action() {
    return
        //  Obx(
        // () =>
        SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyles.primaryMedium(),
        onPressed: () {},
        // onPressed: controller.isLoading
        //     ? null
        //     : () {
        //         FocusManager.instance.primaryFocus?.unfocus();
        //         controller.submit();
        //       },
        child: HyperButton.child(
          // status: controller.isLoading,
          status: true,
          child: Text(
            'Tìm ngay',
            style: buttonBold,
          ),
        ),
      ),
      // ),
    );
  }

  Container _maxTrips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Số chuyến tối đa',
            style: subtitle2.copyWith(color: AppColors.softBlack),
          ),
          Row(
            children: [
              Text(
                '2',
                style: subtitle2.copyWith(color: AppColors.softBlack),
              ),
              Icon(Icons.chevron_right, size: 26.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchInput() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 11.5.h),
                height: 85.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HyperShape.startCircle(),
                    HyperShape.dot(),
                    HyperShape.dot(),
                    HyperShape.dot(),
                    HyperShape.endCircle(),
                  ],
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 3.5.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _textField(
                              onPressed: () {
                                controller.initStart();
                                Get.toNamed(Routes.BUSING_SEARCH_START);
                              },
                              labelText: 'Điểm đi',
                              hintText: 'Chọn điểm đi',
                              textController:
                                  controller.startTextEditingController,
                            ),
                            _textField(
                              onPressed: () {
                                controller.initEnd();
                                Get.toNamed(Routes.BUSING_SEARCH_END);
                              },
                              labelText: 'Điểm đến',
                              hintText: 'Chọn điểm đến',
                              textController:
                                  controller.endTextEditingController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Obx(
                        () => ElevatedButton(
                          onPressed:
                              controller.canSwap ? controller.swap : null,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: AppColors.blue,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size(40.r, 40.r),
                          ),
                          child: SizedBox(
                            height: 40.r,
                            width: 40.r,
                            child: Icon(
                              Icons.swap_vert,
                              size: 23.r,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required Function() onPressed,
    required String hintText,
    required String labelText,
    required TextEditingController textController,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: TextFormField(
          controller: textController,
          enabled: false,
          cursorColor: AppColors.blue,
          style: subtitle1.copyWith(
            color: AppColors.lightBlack,
          ),
          decoration: InputStyles.map(
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
