import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/widgets/search_item.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:tiengviet/tiengviet.dart';

import 'package:latlong2/latlong.dart';

class RentingController extends BaseController
    with GetTickerProviderStateMixin {
  var urlTemplate = BuildConfig.instance.config.mapboxUrlTemplate.obs;
  String accessToken = BuildConfig.instance.config.mapboxAccessToken;
  String mapId = BuildConfig.instance.config.mapboxId;

  final Repository _repository = Get.find(tag: (Repository).toString());
  final MapboxRepository _mapboxRepository =
      Get.find(tag: (MapboxRepository).toString());
  RentStations? rentStations;

  MapController mapController = MapController();

  List<Widget> searchItems = [];
  List<Marker> markers = [];
  Map<String, Items> rentStationsData = {};

  String? selectedStationId;
  bool get isSelectedStation => selectedStationId != null;
  Items? get selectedStation => rentStationsData[selectedStationId];

  double defaultZoomLevel = 10.8;
  double defaultZoomBigLevel = 13.7;
  double zoomLevel = 10.8;
  late Position currentPosition;
  late LatLng currentLngLat;

  LatLngBounds? currentBounds;

  @override
  void onInit() async {
    await _loadCenter();
    await _getRentStations();
    _goToCenter();
    super.onInit();
  }

  void clearSelectedMarker() {
    selectedStationId = null;
    update();
  }

  void _goToCenter({double? zoom}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _moveToPosition(currentLngLat, zoom: zoom ?? defaultZoomBigLevel);
  }

  Future<void> _loadCenter() async {
    currentPosition = await determinePosition();
    currentLngLat = LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void goToCurrentLocation() async {
    await _loadCenter();
    _moveToPosition(currentLngLat, zoom: mapController.zoom);
  }

  void unFocus() {
    selectedStationId = null;
  }

  void _selectStatiton(String stationId) {
    selectedStationId = stationId;
  }

  void onPositionChanged(MapPosition position, bool hasGesture) {
    zoomLevel = position.zoom ?? defaultZoomLevel;
    debugPrint('Nam: $zoomLevel');
  }

  void onMapCreated(MapController controller) {
    // TODO
  }

  void _moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    _animatedMapMove(position, zoomLevel);
  }

  Future<void> _getRentStations() async {
    var rentStationsService = _repository.getRentStations();

    await callDataService(
      rentStationsService,
      onSuccess: (RentStations? response) {
        rentStations = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    markers.clear();
    rentStationsData.clear();
    var items = rentStations?.body?.items ?? [];
    for (Items item in items) {
      double lat = item.latitude ?? 0;
      double lng = item.longitude ?? 0;

      var itemId = item.id ?? '';
      var location = LatLng(lat, lng);

      rentStationsData[itemId] = item;

      markers.add(
        Marker(
          width: 80.r,
          height: 80.r,
          point: location,
          builder: (context) {
            Widget result = Container(
              padding: EdgeInsets.all(20.r),
              child: GestureDetector(
                onTap: () {
                  _selectStatiton(itemId);
                  _moveToPosition(location);
                  update();
                },
                child: Container(
                  color: AppColors.white.withOpacity(0),
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(
                    AppAssets.rentingMapIcon,
                  ),
                ),
              ),
            );
            if (selectedStationId == itemId) {
              result = Container(
                padding: EdgeInsets.only(bottom: 40.r),
                child: GestureDetector(
                  onTap: () {
                    _selectStatiton(itemId);
                    _moveToPosition(location);
                    update();
                  },
                  child: SvgPicture.asset(
                    AppAssets.locationOnIcon,
                  ),
                ),
              );
            }
            return result;
          },
        ),
      );
    }

    update();
  }

  bool _contains(String? text, String? keyword) {
    if (text == null || keyword == null) {
      return false;
    }
    var unSignText = TiengViet.parse(text.toLowerCase().trim());
    var unSignKeyword = TiengViet.parse(keyword.toLowerCase().trim());
    return unSignText.contains(unSignKeyword);
  }

  void clearSearchItems() {
    searchItems.clear();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchItems.clear();
      update();
      return;
    }
    if (rentStations != null) {
      searchItems.clear();
      var items = rentStations?.body?.items ?? [];
      for (Items item in items) {
        if (_contains(item.title, query) || _contains(item.address, query)) {
          var searchItem = SearchItem(
            title: item.title ?? '',
            description: item.address ?? '',
            onPressed: () {},
          );
          searchItems.add(searchItem);
        }
      }
    }

    update();
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

  // FIND ROUTE
  var isFindingRouteObs = false.obs;
  bool get isFindingRoute => isFindingRouteObs.value;
  set isFindingRoute(bool value) {
    isFindingRouteObs.value = value;
  }

  List<LatLng> routePoints = [];
  bool get hasRoute => routePoints.isNotEmpty;

  void _centerZoomFitBounds(LatLngBounds bounds) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    _animatedMapMove(centerZoom.center, centerZoom.zoom);
  }

  void clearRoute() {
    routePoints.clear();
    goToSelectedStation();
    update();
  }

  void findRoute() async {
    isFindingRoute = true;

    if (!isSelectedStation) return;

    routePoints.clear();

    await _loadCenter();
    LatLng from = currentLngLat;
    LatLng to = LatLng(
      selectedStation?.latitude ?? 0,
      selectedStation?.longitude ?? 0,
    );
    var loginService = _mapboxRepository.findRoute(from, to);

    await callDataService(
      loginService,
      onSuccess: (List<LatLng> response) {
        routePoints = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    currentBounds = LatLngBounds();
    for (LatLng point in routePoints) {
      currentBounds?.extend(point);
    }
    currentBounds?.pad(0.48);
    _centerZoomFitBounds(currentBounds!);

    isFindingRoute = false;
    update();
  }

  void goToSelectedStation() {
    if (selectedStation == null) return;

    double lat = selectedStation?.latitude ?? 0;
    double lng = selectedStation?.longitude ?? 0;

    var location = LatLng(lat, lng);
    _moveToPosition(location);
  }

  // GO TO NAVIGATION PAGE
  var isNavigationMode = false.obs;
  double navigationZoomLevel = 17;

  void goToNavigationPage() async {
    isNavigationMode.value = true;
    urlTemplate.value = BuildConfig.instance.config.mapboxNavigationUrlTemplate;
    await _loadCenter();
    _goToCenter(zoom: navigationZoomLevel);
    update();
  }

  void goBackFromNavigationPage() {
    isNavigationMode.value = false;
    urlTemplate.value = BuildConfig.instance.config.mapboxUrlTemplate;
    _centerZoomFitBounds(currentBounds!);
    update();
  }
}
