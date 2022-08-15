import 'package:flutter_map/flutter_map.dart';
import 'package:hyper_driver/app/core/controllers/animated_map_controller.dart';
import 'package:latlong2/latlong.dart';

class MapMoveController {
  MapController mapController;

  MapMoveController(this.mapController);

  void moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    AnimatedMapController.instance.move(position, zoomLevel);
  }

  void centerZoomFitBounds(LatLngBounds bounds) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    AnimatedMapController.instance.move(centerZoom.center, centerZoom.zoom);
  }
}
