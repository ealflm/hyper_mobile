import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/core/widgets/unfocus.dart';

import '../controllers/renting_controller.dart';

class RentingSearchView extends GetView<RentingController> {
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
              _searchItem(
                title: 'Trạm số 1',
                description: '23 Tháng 3, Nghĩa Tân, Gia Nghĩa',
              ),
              _searchItem(
                title: 'Trạm số 1',
                description: '23 Tháng 3, Nghĩa Tân, Gia Nghĩa',
              ),
              _searchItem(
                title: 'Trạm số 1',
                description: '23 Tháng 3, Nghĩa Tân, Gia Nghĩa',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _searchItem({String title = '', String description = ''}) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
        top: 10.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35.r,
            width: 35.r,
            decoration: const BoxDecoration(
              color: AppColors.softGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.softBlack,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                  ),
                ),
                Text(
                  description,
                  style: body2.copyWith(
                    color: AppColors.description,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          ),
        ],
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
                      hintText: 'Tìm kiếm trạm',
                    ),
                    autofocus: true,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Vui lòng nhập mã PIN để tiếp tục';
                      }
                      return null;
                    },
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
