import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:latlong2/latlong.dart';

abstract class GoongRepository {
  Future<Directions> findRoute(LatLng from, LatLng to);
}
