import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/models/place_model.dart';
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
      "vehicle": "bike",
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

  @override
  Future<Place> search(
    String query, {
    LatLng? location,
    int radius = 50,
    int limit = 100,
  }) {
    location = location ?? LatLng(10.212180, 104.018156);

    var endpoint = "https://rsapi.goong.io/Place/AutoComplete";
    var param = {
      "input": query,
      "location": "${location.latitude},${location.longitude}",
      "limit": limit,
      "radius": radius,
    };
    var dioCall = dioGoong.get(
      endpoint,
      queryParameters: param,
    );

    try {
      return callApi(dioCall).then((response) {
        return Place.fromJson(response.data);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlaceDetail> getPlaceDetail(String id) {
    var endpoint = "https://rsapi.goong.io/Place/Detail";
    var param = {
      "place_id": id,
    };
    var dioCall = dioGoong.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) {
        return PlaceDetail.fromJson(response.data['result']);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getPlaceId(LatLng location) {
    var endpoint = "https://rsapi.goong.io/Geocode";
    var param = {
      "latlng": "${location.latitude},${location.longitude}",
    };
    var dioCall = dioGoong.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) {
        return response.data['results'][0]['place_id'];
      });
    } catch (e) {
      rethrow;
    }
  }
}
