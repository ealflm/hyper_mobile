import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_controller.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:latlong2/latlong.dart';

class HyperMap extends GetWidget<BusingController> {
  const HyperMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HyperStack(
      children: [
        FlutterMap(
          mapController: controller.mapController.controller,
          options: MapOptions(
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
                urlTemplate: BuildConfig.instance.mapConfig.mapboxUrlTemplate,
                additionalOptions: {
                  'accessToken':
                      BuildConfig.instance.mapConfig.mapboxAccessToken,
                  'id': BuildConfig.instance.mapConfig.mapboxId,
                },
              ),
            ),
            Obx(
              () {
                if (controller.startPlace.value.placeId != null &&
                    controller.endPlace.value.placeId != null) {
                  return PolylineLayerWidget(
                    options: PolylineLayerOptions(
                      polylineCulling: true,
                      saveLayers: true,
                      polylines: [
                        Polyline(
                          isDotted: true,
                          strokeWidth: 4.r,
                          color: AppColors.gray,
                          points: [
                            LatLng(
                              controller.startPlace.value.geometry?.location
                                      ?.lat ??
                                  0,
                              controller.startPlace.value.geometry?.location
                                      ?.lng ??
                                  0,
                            ),
                            LatLng(
                              controller
                                      .endPlace.value.geometry?.location?.lat ??
                                  0,
                              controller
                                      .endPlace.value.geometry?.location?.lng ??
                                  0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Obx(
              () {
                return controller.busStationController.busStationMarkers.value
                            .isNotEmpty &&
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
            Obx(
              () {
                if (controller.startPlace.value.placeId != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: LatLng(
                            controller
                                    .startPlace.value.geometry?.location?.lat ??
                                0,
                            controller
                                    .startPlace.value.geometry?.location?.lng ??
                                0,
                          ),
                          width: 18.r,
                          height: 18.r,
                          builder: (context) => GestureDetector(
                            onTap: controller.focusOnStartPlace,
                            child: HyperShape.startCircle(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Obx(
              () {
                if (controller.endPlace.value.placeId != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: LatLng(
                            controller.endPlace.value.geometry?.location?.lat ??
                                0,
                            controller.endPlace.value.geometry?.location?.lng ??
                                0,
                          ),
                          width: 18.r,
                          height: 18.r,
                          builder: (context) => GestureDetector(
                            onTap: controller.focusOnEndPlace,
                            child: HyperShape.endCircle(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
