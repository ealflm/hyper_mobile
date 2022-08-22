import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/modules/feedback_driver/controllers/feedback_driver_controller.dart';

class Stars extends GetView<FeedbackDriverController> {
  const Stars({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _star(
            controller.feedBackPoint.value >= 1,
            () {
              controller.changePoint(1);
            },
          ),
          _star(
            controller.feedBackPoint.value >= 2,
            () {
              controller.changePoint(2);
            },
          ),
          _star(
            controller.feedBackPoint.value >= 3,
            () {
              controller.changePoint(3);
            },
          ),
          _star(
            controller.feedBackPoint.value >= 4,
            () {
              controller.changePoint(4);
            },
          ),
          _star(
            controller.feedBackPoint.value >= 5,
            () {
              controller.changePoint(5);
            },
          ),
        ],
      ),
    );
  }

  Widget _star(bool state, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        Icons.star,
        size: 40.w,
        color: state ? AppColors.yellow : AppColors.line,
      ),
    );
  }
}
