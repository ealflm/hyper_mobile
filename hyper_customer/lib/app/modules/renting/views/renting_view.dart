import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/input_styles.dart';
import 'package:hyper_customer/app/core/values/map_values.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:hyper_customer/config/build_config.dart';

import '../controllers/renting_controller.dart';

class RentingView extends GetView<RentingController> {
  const RentingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(children: [
          _map(),
          Obx(
            () {
              return controller.rentingState.value == RentingState.navigation
                  ? _navigation()
                  : controller.rentingState.value == RentingState.route
                      ? _route()
                      : _search();
            },
          ),
          _bottom(),
        ]),
      ),
    );
  }

  Widget _navigation() {
    return SafeArea(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () {
          controller.goBackFromNavigation();
        },
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _goToCurrentLocation(),
          Obx(
            () {
              if (controller.rentingState.value == RentingState.route) {
                return _rentStationStartDetail();
              }
              if (controller.rentingState.value == RentingState.select) {
                return _rentStationDetail();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Container _rentStationStartDetail() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      child: Container(
        decoration: BoxDecorations.map(),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.selectedStation?.title ?? '',
              style: subtitle1.copyWith(
                fontSize: 18.sp,
                color: AppColors.softBlack,
              ),
            ),
            Text(
              controller.selectedStation?.address ?? '',
              style: body2.copyWith(
                color: AppColors.description,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 36.h,
                  width: 124.w,
                  child: ElevatedButton(
                    style: ButtonStyles.primarySmall(),
                    onPressed: () {
                      controller.goToNavigation();
                    },
                    child: HyperButton.child(
                      status: false,
                      child: Row(
                        children: [
                          Icon(
                            Icons.navigation_outlined,
                            size: 20.r,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            'Bắt đầu',
                            style: buttonBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _rentStationDetail() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      child: Container(
        decoration: BoxDecorations.map(),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.selectedStation?.title ?? '',
              style: subtitle1.copyWith(
                fontSize: 18.sp,
                color: AppColors.softBlack,
              ),
            ),
            Text(
              controller.selectedStation?.address ?? '',
              style: body2.copyWith(
                color: AppColors.description,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => SizedBox(
                    height: 36.h,
                    width: 124.w,
                    child: ElevatedButton(
                      style: ButtonStyles.primarySmall(),
                      onPressed: controller.isFindingRoute.value
                          ? null
                          : () {
                              controller.findRoute();
                            },
                      child: HyperButton.child(
                        status: controller.isFindingRoute.value,
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_outlined,
                              size: 20.r,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              'Đường đi',
                              style: buttonBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              controller.goToCurrentLocation();
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

  Widget _route() {
    return Container(
      decoration: BoxDecorations.map(),
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    controller.clearRoute();
                  },
                  style: TextButton.styleFrom(
                    primary: AppColors.blue,
                    shape: const CircleBorder(),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    minimumSize: Size(40.r, 40.r),
                  ),
                  child: SizedBox(
                    height: 40.r,
                    width: 40.r,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.r,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  padding: EdgeInsets.only(top: 11.5.h),
                  height: 85.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _startIcon(),
                      _dotIcon(),
                      _dotIcon(),
                      _dotIcon(),
                      _endIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 3.5.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                enabled: false,
                                cursorColor: AppColors.blue,
                                style: subtitle1.copyWith(
                                  color: AppColors.lightBlack,
                                ),
                                initialValue: 'Vị trí của bạn',
                                decoration: InputStyles.map(
                                  hintText: 'Chọn điểm đi',
                                  labelText: 'Điểm đi',
                                ),
                              ),
                              TextFormField(
                                enabled: false,
                                cursorColor: AppColors.blue,
                                style: subtitle1.copyWith(
                                  color: AppColors.lightBlack,
                                ),
                                initialValue:
                                    controller.selectedStation?.title ?? '',
                                decoration: InputStyles.map(
                                  hintText: 'Chọn điểm đến',
                                  labelText: 'Điểm đến',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        ElevatedButton(
                          onPressed: null,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Container _startIcon() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 6, color: AppColors.blue),
      ),
    );
  }

  Container _dotIcon() {
    return Container(
      width: 3.r,
      height: 3.r,
      decoration: BoxDecoration(
        color: AppColors.indicator,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Container _endIcon() {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.blue,
        border: Border.all(
          width: 6,
          color: AppColors.fadeBlue,
        ),
      ),
    );
  }

  SafeArea _search() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 10.w,
          right: 10.w,
        ),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back();
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
                  Icons.arrow_back_ios_new,
                  size: 18.r,
                  color: AppColors.gray,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.RENTING_SEARCH);
                },
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: AppColors.surface,
                    boxShadow: ShadowStyles.map,
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputStyles.mapSearch(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 22.r,
                        color: AppColors.lightBlack,
                      ),
                      hintText: 'Tìm kiếm trạm',
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Vui lòng nhập mã PIN để tiếp tục';
                      }
                      return null;
                    },
                    // onSaved: (value) => controller.password = value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlutterMap _map() {
    return FlutterMap(
      mapController: controller.mapController,
      options: MapValues.options,
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: BuildConfig.instance.mapConfig.mapboxUrlTemplate,
            additionalOptions: {
              'accessToken': BuildConfig.instance.mapConfig.mapboxAccessToken,
              'id': BuildConfig.instance.mapConfig.mapboxId,
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.clearSelectedStation();
          },
          child: Container(
            color: AppColors.white.withOpacity(0),
          ),
        ),
        HyperStack(
          children: [
            Obx(
              () {
                return controller.rentingState.value == RentingState.route ||
                        controller.rentingState.value == RentingState.navigation
                    ? PolylineLayerWidget(
                        options: PolylineLayerOptions(
                          polylineCulling: false,
                          polylines: [
                            Polyline(
                              strokeWidth: 4.r,
                              color: AppColors.blue,
                              borderStrokeWidth: 3.r,
                              borderColor: AppColors.darkBlue,
                              points: controller.routePoints,
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            GetBuilder<RentingController>(
              builder: (_) {
                return MarkerLayerWidget(
                  options: MarkerLayerOptions(
                    markers: controller.markers,
                  ),
                );
              },
            ),
          ],
        ),
        IgnorePointer(
          child: LocationMarkerLayerWidget(
            options: LocationMarkerLayerOptions(
              showHeadingSector: false,
              marker: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: ShadowStyles.locationMarker,
                ),
                child: DefaultLocationMarker(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2.r),
                    child: Center(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 16.r,
                      ),
                    ),
                  ),
                ),
              ),
              markerSize: Size(26.r, 26.r),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ),
      ],
    );
  }
}
