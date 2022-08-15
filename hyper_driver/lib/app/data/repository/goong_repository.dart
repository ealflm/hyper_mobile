import 'package:hyper_driver/app/data/models/directions_model.dart';
import 'package:hyper_driver/app/data/models/place_detail_model.dart';
import 'package:hyper_driver/app/data/models/place_model.dart';
import 'package:latlong2/latlong.dart';

abstract class GoongRepository {
  Future<Directions> findRoute(LatLng from, LatLng to);
  Future<Place> search(String query);
  Future<PlaceDetail> getPlaceDetail(String id);
  Future<String> getPlaceId(LatLng location);
}
