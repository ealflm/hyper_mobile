import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/map_values.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:lottie/lottie.dart';

import '../controllers/renting_controller.dart';

class HyperMap extends GetWidget<RentingController> {
  const HyperMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller.mapController,
      options: MapValues.options,
      children: [
        Obx(
          () => TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: controller.rentingState.value ==
                      RentingState.navigation
                  ? BuildConfig.instance.mapConfig.mapboxNavigationUrlTemplate
                  : BuildConfig.instance.mapConfig.mapboxUrlTemplate,
              additionalOptions: {
                'accessToken': BuildConfig.instance.mapConfig.mapboxAccessToken,
                'id': BuildConfig.instance.mapConfig.mapboxId,
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.unfocus();
          },
          child: Container(
            color: AppColors.white.withOpacity(0),
          ),
        ),
        HyperStack(
          children: [
            Obx(
              () {
                switch (controller.rentingState.value) {
                  case RentingState.normal:
                    return Container();
                  case RentingState.select:
                    return Container();
                  case RentingState.route:
                    return PolylineLayerWidget(
                      options: PolylineLayerOptions(
                        polylineCulling: true,
                        saveLayers: true,
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
                    );
                  case RentingState.navigation:
                    return PolylineLayerWidget(
                      options: PolylineLayerOptions(
                        polylineCulling: true,
                        saveLayers: true,
                        polylines: [
                          Polyline(
                            strokeWidth: 7.r,
                            gradientColors: [
                              AppColors.purpleStart,
                              AppColors.purpleStart,
                              AppColors.purpleStart,
                              AppColors.purpleStart,
                              AppColors.purpleEnd,
                            ],
                            borderStrokeWidth: 3.r,
                            borderColor: AppColors.white,
                            points: controller.routePoints,
                          ),
                        ],
                      ),
                    );
                  default:
                    return Container();
                }
              },
            ),
            Obx(
              () {
                return controller.legPolyLine.value.isNotEmpty
                    ? PolylineLayerWidget(
                        options: PolylineLayerOptions(
                          polylineCulling: true,
                          saveLayers: true,
                          polylines: [
                            Polyline(
                              strokeWidth: 4.r,
                              color: AppColors.blue,
                              borderStrokeWidth: 3.r,
                              borderColor: AppColors.darkBlue,
                              points: controller.legPolyLine.value,
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
              moveAnimationDuration: const Duration(milliseconds: 800),
              showHeadingSector: false,
              markerSize: Size(60.r, 60.r),
              markerDirection: MarkerDirection.heading,
              marker: Obx(
                () {
                  switch (controller.rentingState.value) {
                    case RentingState.navigation:
                      return Stack(
                        children: [
                          Lottie.asset(AppAnimationAssets.scanPulsePurple),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: ShadowStyles.locationMarker,
                              ),
                              height: 26.r,
                              width: 26.r,
                              child: DefaultLocationMarker(
                                color: AppColors.purpleStart,
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
                          ),
                        ],
                      );
                    default:
                      return Stack(
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: ShadowStyles.locationMarker,
                              ),
                              height: 26.r,
                              width: 26.r,
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
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
