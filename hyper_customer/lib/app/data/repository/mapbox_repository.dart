import 'package:latlong2/latlong.dart';

abstract class MapboxRepository {
  Future<String> findRoute(LatLng from, LatLng to);
}
