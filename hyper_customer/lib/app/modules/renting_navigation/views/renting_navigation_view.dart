import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';
import 'package:hyper_customer/app/modules/renting_navigation/controllers/renting_navigation_controller.dart';

import 'package:latlong2/latlong.dart';

class RentingNavigationView extends GetView<RentingNavigationController> {
  const RentingNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(children: [
          _map(),
        ]),
      ),
    );
  }

  FlutterMap _map() {
    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        center: LatLng(10.212884, 103.964889),
        zoom: 10.8,
        minZoom: 10.8,
        maxZoom: 18.4,
        swPanBoundary: LatLng(9.866505, 103.785063),
        nePanBoundary: LatLng(10.508632, 104.112881),
        slideOnBoundaries: true,
        onMapCreated: controller.onMapCreated,
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: controller.urlTemplate,
            additionalOptions: {
              'accessToken': controller.accessToken,
              'id': controller.mapId,
            },
          ),
        ),
        HyperStack(
          children: [
            PolylineLayerWidget(
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
              moveAnimationDuration: const Duration(seconds: 2),
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
