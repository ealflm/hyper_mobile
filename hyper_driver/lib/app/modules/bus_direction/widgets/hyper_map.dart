import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/values/app_animation_assets.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/core/values/map_values.dart';
import 'package:hyper_driver/app/core/values/shadow_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_shape.dart';
import 'package:hyper_driver/app/core/widgets/hyper_stack.dart';
import 'package:hyper_driver/app/modules/bus_direction/controllers/bus_direction_controller.dart';
import 'package:hyper_driver/config/build_config.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' hide Marker;

class HyperMap extends GetWidget<BusDirectionController> {
  const HyperMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: controller.isExpanded.value
            ? 1.sh - AppValues.busDirectionMaxHeight + 20.h
            : 1.sh - AppValues.busDirectionMinHeight + 20.h,
        child: HyperStack(
          children: [
            FlutterMap(
              mapController: controller.mapController.controller,
              options: MapOptions(
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                center: LatLng(10.212884, 103.964889),
                zoom: 10.5,
                minZoom: 10.5,
                maxZoom: 18.4,
                slideOnBoundaries: true,
                onPositionChanged: controller.mapController.onPositionChanged,
              ),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate: BuildConfig
                        .instance.mapConfig.mapboxNavigationUrlTemplate,
                    additionalOptions: {
                      'accessToken':
                          BuildConfig.instance.mapConfig.mapboxAccessToken,
                      'id': BuildConfig.instance.mapConfig.mapboxId,
                    },
                  ),
                ),
                Obx(
                  () => controller.polylines.value.isNotEmpty
                      ? Stack(
                          children: controller.polylines.value,
                        )
                      : Container(),
                ),
                Obx(
                  () => controller.selectedPolylines.value != null
                      ? controller.selectedPolylines.value ?? Container()
                      : Container(),
                ),
                GestureDetector(
                  onTap: () {
                    controller.busStationController.clearBusStation();
                  },
                  child: Container(
                    color: AppColors.white.withOpacity(0),
                  ),
                ),
                Obx(
                  () {
                    return controller.busStationController.busStationMarkers
                                .value.isNotEmpty &&
                            controller.mapController.isShowBusStationMarker()
                        ? MarkerLayerWidget(
                            options: MarkerLayerOptions(
                              markers: controller
                                  .busStationController.busStationMarkers.value,
                            ),
                          )
                        : Container();
                  },
                ),
                IgnorePointer(
                  child: Obx(
                    () => controller.startMarker.value != null
                        ? MarkerLayerWidget(
                            options: MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: controller.startMarker.value!,
                                  width: 18.r,
                                  height: 18.r,
                                  builder: (context) =>
                                      HyperShape.startCircle(),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ),
                IgnorePointer(
                  child: Obx(
                    () => controller.endMarker.value != null
                        ? MarkerLayerWidget(
                            options: MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: controller.endMarker.value!,
                                  width: 60.r,
                                  height: 60.r,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                        bottom: 28.r,
                                      ),
                                      child: SvgPicture.asset(
                                          AppAssets.locationOnIcon),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ),
                IgnorePointer(
                  child: LocationMarkerLayerWidget(
                    options: LocationMarkerLayerOptions(
                      moveAnimationDuration: const Duration(milliseconds: 800),
                      showHeadingSector: false,
                      markerSize: Size(60.r, 60.r),
                      markerDirection: MarkerDirection.heading,
                      marker: Stack(
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
}
