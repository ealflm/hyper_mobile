import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:latlong2/latlong.dart';

class RentingNavigationController extends GetxController {
  String urlTemplate = BuildConfig.instance.config.mapUrlTemplate;
  String accessToken = BuildConfig.instance.config.mapAccessToken;
  String mapId = BuildConfig.instance.config.mapId;

  MapController mapController = MapController();

  List<LatLng> routePoints = [];
  List<Marker> markers = [];

  @override
  void onInit() {
    if (Get.arguments != null) {
      routePoints = Get.arguments['routePoints'];
      markers = Get.arguments['markers'];
    }
    super.onInit();
  }

  @override
  void onReady() {
    if (routePoints.isEmpty || markers.isEmpty) {
      Utils.showToast('Kết nối thất bại');
      Get.back();
    }
    super.onReady();
  }

  void onMapCreated(MapController controller) {
    // TODO
  }
}
