import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';
import 'package:hyper_driver/app/modules/pick-up/widgets/finished.dart';
import 'package:hyper_driver/app/modules/pick-up/widgets/picked.dart';

import '../../../core/controllers/hyper_map_controller.dart';

class Bottom extends GetWidget<PickUpController> {
  const Bottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _goToCurrentLocation(),
          Obx(
            () {
              switch (controller.state.value) {
                case ViewState.picked:
                  return const Picked();
                case ViewState.finished:
                  return const Finished();
                case ViewState.completed:
                  return Text('TODO');
              }
            },
          ),
        ],
      ),
    );
  }

  Container _goToCurrentLocation() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              HyperMapController.instance.moveToCurrentLocation();
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
                Icons.gps_fixed,
                size: 18.r,
                color: AppColors.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
