import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/config/build_config.dart';

class RentingController extends GetxController {
  String urlTemplate = BuildConfig.instance.config.mapUrlTemplate;
  String accessToken = BuildConfig.instance.config.mapAccessToken;
  String mapId = BuildConfig.instance.config.mapId;

  MapController? mapController;

  void onMapCreated(MapController controller) {
    mapController = controller;
  }
}
