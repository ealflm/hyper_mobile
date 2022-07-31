import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/map_values.dart';
import 'package:hyper_customer/app/core/values/shadow_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_stack.dart';
import 'package:hyper_customer/app/modules/bus_direction/controllers/bus_direction_controller.dart';
import 'package:hyper_customer/config/build_config.dart';

class HyperMap extends GetWidget<BusDirectionController> {
  const HyperMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HyperStack(
      children: [
        FlutterMap(
          mapController: controller.mapController,
          options: MapValues.options,
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
