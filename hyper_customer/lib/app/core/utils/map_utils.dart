import 'package:latlong2/latlong.dart' as ll;
import 'package:maps_toolkit/maps_toolkit.dart';

class MapUtils {
  static double distance(ll.LatLng from, ll.LatLng to) {
    LatLng a = LatLng(from.latitude, from.longitude);
    LatLng b = LatLng(to.latitude, to.longitude);
    return SphericalUtil.computeDistanceBetween(a, b).toDouble();
  }

  static bool isInRoute(ll.LatLng point, List<ll.LatLng> points) {
    LatLng p = LatLng(point.latitude, point.longitude);
    List<LatLng> ps =
        points.map((ll.LatLng p) => LatLng(p.latitude, p.longitude)).toList();

    return PolygonUtil.isLocationOnPath(p, ps, true, tolerance: 100);
  }
}
