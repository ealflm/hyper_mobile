import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:latlong2/latlong.dart';

class MapboxRepositoryImpl extends BaseRepository implements MapboxRepository {
  @override
  Future<String> findRoute(LatLng from, LatLng to,
      {String routingProfile = 'driving'}) {
    var fromTo =
        '${from.latitude},${from.longitude};${to.latitude},${to.longitude}';

    var endpoint =
        "https://api.mapbox.com/directions/v5/mapbox/$routingProfile/$fromTo";
    var param = {
      "annotations": "distance%2Cduration%2Cspeed%2Ccongestion",
      "overview": "full",
      "geometries": "geojson",
      "alternatives": "true",
      "steps": "true",
    };
    var dioCall = dioMapbox.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) => response.data);
    } catch (e) {
      rethrow;
    }
  }
}
