import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_search_route_controller.dart';
import 'package:hyper_customer/app/modules/busing/controllers/search_text_filed_controller.dart';
import 'package:hyper_customer/app/modules/busing/widgets/option_item.dart';

class BusingSearchEndView extends GetView<BusingSearchRouteController> {
  const BusingSearchEndView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Unfocus(
        child: Scaffold(
          body: Column(
            children: [
              _searchBar(),
              SizedBox(
                height: 10.h,
              ),
              OptionItem(
                icon: Icons.gps_fixed,
                title: 'Vị trí của bạn',
                onPressed: () {
                  // Get.toNamed('/busing/search/location');
                },
              ),
              OptionItem(
                icon: Icons.location_pin,
                title: 'Chọn trên bản đồ',
                onPressed: () {
                  // Get.toNamed('/busing/search/location');
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () {
                  if (controller.endSearchItems.value.isEmpty &&
                      controller.endSearchEditingController.text.isEmpty) {
                    return Text(
                      'Nhập dữ liệu để tìm kiếm',
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    );
                  }
                  if (controller.endSearchItems.value.isEmpty) {
                    return Text(
                      'Không có kết quả',
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    );
                  }
                  return Column(
                    children: controller.endSearchItems.value,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _searchBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      padding:
          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
      child: Wrap(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: AppColors.surface,
                  ),
                  child: GetBuilder<SearchTextFieldController>(
                    init: SearchTextFieldController(
                        controller.endSearchEditingController),
                    builder: (textFieldController) {
                      return TextFormField(
                        controller: controller.endSearchEditingController,
                        onFieldSubmitted: controller.endOnSearchChanged,
                        onChanged: controller.endOnSearchChanged,
                        textInputAction: TextInputAction.search,
                        focusNode: textFieldController.focusNode,
                        decoration: InputStyles.mapSearchOutlined(
                          prefixIcon: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                              height: 22.w,
                              width: 22.w,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18.r,
                                color: AppColors.lightBlack,
                              ),
                            ),
                          ),
                          hintText: 'Chọn điểm đến',
                          state: textFieldController.isShowClear,
                          suffixAction: () {
                            textFieldController.clearSearchField();
                          },
                        ),
                        autofocus: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
