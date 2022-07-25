import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:latlong2/latlong.dart';

class GoongRepositoryImpl extends BaseRepository implements GoongRepository {
  @override
  Future<Directions> findRoute(LatLng from, LatLng to,
      {String routingProfile = 'driving'}) {
    var endpoint = "https://rsapi.goong.io/Direction";
    var param = {
      "origin": "${from.latitude},${from.longitude}",
      "destination": "${to.latitude},${to.longitude}",
      "vehicle": "car",
    };
    var dioCall = dioGoong.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) {
        return Directions.fromJson(response.data);
      });
    } catch (e) {
      rethrow;
    }
  }
}
