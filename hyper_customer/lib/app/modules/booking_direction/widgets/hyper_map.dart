import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:latlong2/latlong.dart';

class HyperMap extends GetWidget<BookingDirectionController> {
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
                return controller.hasRoute.value
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
                              points: controller.routePoints,
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            Obx(
              () {
                if (controller.startPlace.value != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: controller.startPlaceLocation ?? LatLng(0, 0),
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
                if (controller.endPlace.value != null) {
                  return MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: controller.endPlaceLocation ?? LatLng(0, 0),
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
