import 'package:flutter_map/flutter_map.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:latlong2/latlong.dart';

class RentingMapController {
  MapController mapController;
  AnimatedMapController animatedMapController;

  RentingMapController(this.mapController, this.animatedMapController);

  void moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    animatedMapController.move(position, zoomLevel);
  }

  void centerZoomFitBounds(LatLngBounds bounds) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    animatedMapController.move(centerZoom.center, centerZoom.zoom);
  }
}
