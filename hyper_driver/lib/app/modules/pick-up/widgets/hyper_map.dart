import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/values/app_animation_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/shadow_styles.dart';
import 'package:hyper_driver/app/core/widgets/hyper_shape.dart';
import 'package:hyper_driver/app/core/widgets/hyper_stack.dart';
import 'package:hyper_driver/app/modules/pick-up/controllers/pick_up_controller.dart';
import 'package:hyper_driver/config/build_config.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' hide Marker;

import '../../../core/controllers/hyper_map_controller.dart';

class HyperMap extends GetWidget<PickUpController> {
  const HyperMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HyperStack(
      children: [
        FlutterMap(
          options: MapOptions(
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            center: LatLng(10.212884, 103.964889),
            zoom: 10.5,
            minZoom: 10.5,
            maxZoom: 18.4,
            slideOnBoundaries: true,
            onMapCreated:
                HyperMapController.instance.onMapCreatedGoCurrentLocation,
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
                return controller.routePoints.value.isNotEmpty
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
                              points: controller.routePoints.value,
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            Obx(
              () {
                if (controller.startMarkerLocation.value != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: controller.startMarkerLocation.value ??
                              LatLng(0, 0),
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
                if (controller.endMarkerLocation.value != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: controller.endMarkerLocation.value ??
                              LatLng(0, 0),
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
            Obx(
              () => Opacity(
                opacity: SignalR.instance.activityState.value ? 1 : 0,
                child: LocationMarkerLayerWidget(
                  options: LocationMarkerLayerOptions(
                    moveAnimationDuration: const Duration(milliseconds: 800),
                    showHeadingSector: false,
                    markerSize: Size(90.r, 90.r),
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
                              color: AppColors.primary400,
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
            ),
            Obx(
              () => Opacity(
                opacity: SignalR.instance.activityState.value ? 0 : 1,
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
            ),
          ],
        ),
      ],
    );
  }
}
