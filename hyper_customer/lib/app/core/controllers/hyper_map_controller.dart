import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_position_stream.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:latlong2/latlong.dart';

class HyperMapController {
  MapController controller = MapController();
  HyperPositionStream? _positionStream;
  final MapLocationController _mapLocationController = MapLocationController();

  HyperMapController() {
    _mapLocationController.loadLocation();
  }

  Future<LatLng?> getCurrentLocation() async {
    await _mapLocationController.loadLocation();
    return _mapLocationController.location;
  }

  void moveToCurrentLocation({double? zoom}) async {
    LatLng? currentLocation = await getCurrentLocation();
    if (currentLocation == null) return;
    moveToPosition(
      currentLocation,
      zoom: zoom ?? AppValues.focusZoomLevel,
    );
  }

  void moveToPosition(LatLng position, {double? zoom}) {
    AnimatedMapController.init(controller: controller);
    var zoomLevel = zoom ?? controller.zoom;
    AnimatedMapController.instance.move(position, zoomLevel);
  }

  void centerZoomFitBounds(LatLngBounds bounds) {
    AnimatedMapController.init(controller: controller);
    var centerZoom = controller.centerZoomFitBounds(bounds);
    AnimatedMapController.instance.move(centerZoom.center, centerZoom.zoom);
  }

  void initPostionStream({required Function() onPositionChanged}) {
    _positionStream = HyperPositionStream(onPositionChanged: onPositionChanged);
  }

  void pausePositionStream() {
    _positionStream?.pausePositionStream();
  }

  void resumePostionStream() {
    _positionStream?.resumePositionStream();
  }

  void closePostionStream() {
    _positionStream?.close();
  }

  Rx<MapPosition?> postion = Rx<MapPosition?>(null);

  bool isShowBusStationMarker() {
    var zoom = postion.value?.zoom ?? 18.4;
    return zoom >= AppValues.showBusStationMarkerZoomLevel;
  }

  void onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    postion.value = mapPosition;
  }
}
