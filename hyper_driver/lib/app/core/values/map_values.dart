import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapValues {
  static MapOptions options = MapOptions(
    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
    center: LatLng(10.212884, 103.964889),
    zoom: 10.8,
    minZoom: 10.8,
    maxZoom: 18.4,
    // swPanBoundary: LatLng(9.866505, 103.785063),
    // nePanBoundary: LatLng(10.508632, 104.112881),
    slideOnBoundaries: true,
  );

  static MapOptions busingOptions = MapOptions(
    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
    center: LatLng(10.212884, 103.964889),
    zoom: 10.5,
    minZoom: 10.5,
    maxZoom: 18.4,
    // swPanBoundary: LatLng(9.866505, 103.785063),
    // nePanBoundary: LatLng(10.508632, 104.112881),
    slideOnBoundaries: true,
  );
}
