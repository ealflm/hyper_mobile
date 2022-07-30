import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/models/place_model.dart';
import 'package:latlong2/latlong.dart';

abstract class GoongRepository {
  Future<Directions> findRoute(LatLng from, LatLng to);
  Future<Place> search(String query);
  Future<PlaceDetail> getPlaceDetail(String id);
}
