import 'package:latlong2/latlong.dart';

abstract class MapboxRepository {
  Future<List<LatLng>> findRoute(LatLng from, LatLng to);
}
