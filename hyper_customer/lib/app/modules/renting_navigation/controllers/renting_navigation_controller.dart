import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:latlong2/latlong.dart';

class RentingNavigationController extends GetxController
    with GetTickerProviderStateMixin {
  String urlTemplate = BuildConfig.instance.config.mapboxNavigationUrlTemplate;
  String accessToken = BuildConfig.instance.config.mapboxAccessToken;
  String mapId = BuildConfig.instance.config.mapboxId;

  MapController mapController = MapController();

  List<LatLng> routePoints = [];
  List<Marker> markers = [];

  @override
  void onInit() async {
    if (Get.arguments != null) {
      routePoints = Get.arguments['routePoints'];
      markers = Get.arguments['markers'];
    }

    _goToCenter();
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

  // Go to current location

  double defaultZoomLevel = 10.8;
  double defaultZoomBigLevel = 17;
  double zoomLevel = 10.8;
  late Position currentPosition;
  late LatLng currentLngLat;

  void _goToCenter() async {
    await _loadCenter();
    _moveToPosition(currentLngLat, zoom: defaultZoomBigLevel);
  }

  Future<void> _loadCenter() async {
    currentPosition = await determinePosition();
    currentLngLat = LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void _moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    _animatedMapMove(position, zoomLevel);
  }

  // Animated map
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
