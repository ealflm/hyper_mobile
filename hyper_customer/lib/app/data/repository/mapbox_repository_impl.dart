import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:latlong2/latlong.dart';

class MapboxRepositoryImpl extends BaseRepository implements MapboxRepository {
  @override
  Future<List<LatLng>> findRoute(LatLng from, LatLng to,
      {String routingProfile = 'driving'}) {
    var fromTo =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';

    var endpoint =
        "https://api.mapbox.com/directions/v5/mapbox/$routingProfile/$fromTo";
    var param = {
      "annotations": "distance,duration,speed,congestion",
      "overview": "full",
      "geometries": "geojson",
      "alternatives": "true",
      "steps": "true",
    };
    var dioCall = dioMapbox.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) {
        var list = response.data['routes'][0]['geometry']['coordinates'];
        List<LatLng> result = [];
        for (List item in list) {
          result.add(LatLng(item[1], item[0]));
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }
}
