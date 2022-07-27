import 'package:flutter_map/flutter_map.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:latlong2/latlong.dart';

class RentingMapController {
  MapController mapController;

  RentingMapController(this.mapController);

  void moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    AnimatedMapController.instance.move(position, zoomLevel);
  }

  void centerZoomFitBounds(LatLngBounds bounds) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    AnimatedMapController.instance.move(centerZoom.center, centerZoom.zoom);
  }
}
