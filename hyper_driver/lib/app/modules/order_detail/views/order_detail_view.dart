import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            "Chi tiết dịch vụ",
            style: h6.copyWith(color: AppColors.softBlack),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${controller.order?.serviceTypeName}',
                    style: h6.copyWith(
                      color: AppColors.softBlack,
                      fontWeight: FontWeights.regular,
                    )),
              ],
            ),
            Text(
              DateTimeUtils.dateTimeToString(controller.order?.createdDate),
              style: body1.copyWith(
                color: AppColors.gray,
                fontSize: 14.r,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => ListView.builder(
                itemCount: controller.orderDetails.value.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _detailItem(
                    '${controller.orderDetails.value[index].content}',
                    '${controller.orderDetails.value[index].quantity} x ${NumberUtils.vnd(controller.orderDetails.value[index].price)}',
                  );
                },
              ),
            ),
            const Divider(color: AppColors.line),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Tổng tiền',
                      style: subtitle1.copyWith(
                        fontWeight: FontWeights.regular,
                        color: AppColors.lightBlack,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      NumberUtils.vnd(controller.order?.totalPrice),
                      style: subtitle1.copyWith(
                        color: AppColors.softBlack,
                        fontWeight: FontWeights.medium,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _detailItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: subtitle1.copyWith(
            fontWeight: FontWeights.regular,
            color: AppColors.lightBlack,
          ),
        ),
        Text(
          value,
          style: subtitle1.copyWith(
            color: AppColors.softBlack,
            fontWeight: FontWeights.medium,
          ),
        ),
      ],
    );
  }
}
