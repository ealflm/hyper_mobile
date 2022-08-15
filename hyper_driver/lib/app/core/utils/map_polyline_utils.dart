import 'package:latlong2/latlong.dart';
import 'package:polyline_do/polyline_do.dart';

class MapPolylineUtils {
  static List<LatLng> decode(String encodedString) {
    List<LatLng> result = [];
    var polyline = Polyline.Decode(encodedString: encodedString, precision: 5);
    for (List item in polyline.decodedCoords) {
      result.add(LatLng(item[0], item[1]));
    }
    return result;
  }
}
