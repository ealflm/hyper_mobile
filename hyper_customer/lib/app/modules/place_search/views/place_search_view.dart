import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/place_search/controllers/place_search_controller.dart';
import 'package:hyper_customer/app/modules/place_search/controllers/search_text_filed_controller.dart';
import 'package:hyper_customer/app/modules/place_search/widgets/option_item.dart';

class PlaceSearchView extends GetView<PlaceSearchController> {
  const PlaceSearchView({Key? key}) : super(key: key);
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
              Obx(
                () => controller.allowMyLocation.value
                    ? OptionItem(
                        icon: Icons.gps_fixed,
                        title: AppValues.myLocation,
                        onPressed: () {
                          controller.selectMyLocation();
                        },
                      )
                    : Container(),
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
                  if (controller.searchItems.value.isEmpty &&
                      controller.editingController.text.isEmpty) {
                    return Text(
                      'Nhập dữ liệu để tìm kiếm',
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    );
                  }
                  if (controller.searchItems.value.isEmpty) {
                    return Text(
                      'Không có kết quả',
                      style: body2.copyWith(
                        color: AppColors.description,
                      ),
                    );
                  }
                  return Column(
                    children: controller.searchItems.value,
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
                  child: SearchTextField(controller.editingController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTextField extends GetView<PlaceSearchController> {
  const SearchTextField(
    this.textEditingController, {
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchTextFieldController>(
      init: SearchTextFieldController(textEditingController),
      builder: (searchTextFieldController) {
        return TextFormField(
          focusNode: searchTextFieldController.focusNode,
          controller: searchTextFieldController.editingController,
          onFieldSubmitted: controller.onSearchChanged,
          onChanged: controller.onSearchChanged,
          textInputAction: TextInputAction.search,
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
            hintText: 'Tìm kiếm',
            state: searchTextFieldController.isShowClear,
            suffixAction: () {
              searchTextFieldController.clearSearchField();
            },
          ),
          autofocus: true,
        );
      },
    );
  }
}
