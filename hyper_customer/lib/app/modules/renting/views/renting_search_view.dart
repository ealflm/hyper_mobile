import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_search_controller.dart';

class RentingSearchView extends GetView<RentingSearchController> {
  const RentingSearchView({Key? key}) : super(key: key);
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
              GetBuilder<RentingSearchController>(
                builder: (_) {
                  if (controller.text.isEmpty) {
                    return Text(
                      'Nhập để tìm kiếm',
                      style: body2.copyWith(color: AppColors.description),
                    );
                  } else if (controller.searchItems.isEmpty) {
                    return Text(
                      'Không tìm thấy kết quả',
                      style: body2.copyWith(color: AppColors.description),
                    );
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.searchItems,
                        ),
                      ),
                    );
                  }
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
                  child: TextFormField(
                    onChanged: controller.onSearchChanged,
                    decoration: InputStyles.mapSearchOutlined(
                      prefixIcon: InkWell(
                        onTap: () {
                          controller.clearSearchItems();
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
                      hintText: 'Tìm kiếm trạm',
                    ),
                    autofocus: true,
                    // onSaved: (value) => controller.password = value,
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
