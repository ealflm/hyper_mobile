import 'package:latlong2/latlong.dart' as ll;
import 'package:maps_toolkit/maps_toolkit.dart';

class MapUtils {
  static double distance(ll.LatLng from, ll.LatLng to) {
    LatLng a = LatLng(from.latitude, from.longitude);
    LatLng b = LatLng(to.latitude, to.longitude);
    return SphericalUtil.computeDistanceBetween(a, b).toDouble();
  }
}
