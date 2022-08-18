import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/modules/home/controllers/home_controller.dart';

class Bottom extends GetWidget<HomeController> {
  const Bottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(bottom: AppValues.bottomAppBarHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _goToCurrentLocation(),
        ],
      ),
    );
  }

  Container _goToCurrentLocation() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            children: [
              ElevatedButton(
                onPressed: SignalRController.instance.action1,
                child: const Text('Action 1'),
              ),
              ElevatedButton(
                onPressed: SignalRController.instance.action2,
                child: const Text('Action 2'),
              ),
              ElevatedButton(
                onPressed: SignalRController.instance.action3,
                child: const Text('Action 3'),
              ),
              ElevatedButton(
                onPressed: SignalRController.instance.action4,
                child: const Text('Action 4'),
              ),
              ElevatedButton(
                onPressed: SignalRController.instance.action3,
                child: const Text('Action 4'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
