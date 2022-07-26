import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/animated_map_utils.dart';
import 'package:hyper_customer/app/core/utils/map_utils.dart';
import 'package:hyper_customer/app/core/utils/polylatlng_utils.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';

import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class RentingController extends BaseController
    with GetTickerProviderStateMixin {
  double zoomLevel = 10.8;
  double zoomInLevel = 13.7;
  double navigationZoomLevel = 17;

  final Repository _repository = Get.find(tag: (Repository).toString());
  final MapboxRepository _mapboxRepository =
      Get.find(tag: (MapboxRepository).toString());
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  RentStations? rentStations;
  MapController mapController = MapController();

  List<Widget> searchItems = [];
  Map<String, Items> rentStationsData = {};

  List<Marker> markers = [];

  AnimatedMap? _animatedMap;

  LatLng? currentLocation;
  LatLngBounds? currentBounds;

  String? selectedStationId;
  Items? get selectedStation => rentStationsData[selectedStationId];

  var rentingState = RentingState.normal.obs;

  // Region Init
  @override
  void onInit() async {
    init();
    super.onInit();
  }

  Future<void> init() async {
    _animatedMap = AnimatedMap(controller: mapController, vsync: this);

    await _getCurrentLocation();
    await _fetchRentStations();
    _goToCurrentLocationWithZoomDelay();

    _locationListener();
    positionStream?.pause();
  }
  // End Region

  // Region Fetch Rent Stations
  Future<void> _fetchRentStations() async {
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

    _updateMarker();
  }

  void _updateMarker() {
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
                  child: rentingState.value == RentingState.navigation
                      ? SvgPicture.asset(AppAssets.locationOnPurpleIcon)
                      : SvgPicture.asset(
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

  // End Region

  // Region Fetch Route
  List<LatLng> routePoints = [];
  Directions? directions;
  var isFindingRoute = false.obs;

  void fetchRoute() async {
    if (currentLocation == null) return;
    isFindingRoute.value = true;

    routePoints.clear();

    await _getCurrentLocation();
    LatLng from = currentLocation!;
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

    centerZoomFitBounds();

    isFindingRoute.value = false;
    _changeRentingState(RentingState.route);
  }

  Legs? legs;
  var selectedLegIndex = 0.obs;

  void fetchGoongRoute() async {
    if (currentLocation == null) return;
    isFindingRoute.value = true;

    routePoints.clear();

    await _getCurrentLocation();
    LatLng from = currentLocation!;
    LatLng to = LatLng(
      selectedStation?.latitude ?? 0,
      selectedStation?.longitude ?? 0,
    );
    var loginService = _goongRepository.findRoute(from, to);

    await callDataService(
      loginService,
      onSuccess: (Directions response) {
        directions = response;

        String overviewPolyline =
            directions?.routes?[0].overviewPolyline?.points ?? '';

        legs = directions?.routes?[0].legs?[0];

        routePoints = PolyLatLng.decode(overviewPolyline);
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    centerZoomFitBounds();

    isFindingRoute.value = false;
    _changeRentingState(RentingState.route);
  }

  void centerZoomFitBounds() {
    currentBounds = LatLngBounds();
    for (LatLng point in routePoints) {
      currentBounds?.extend(point);
    }
    currentBounds?.pad(0.52);
    _centerZoomFitBounds(currentBounds!);
  }

  void clearRoute() {
    _changeRentingState(RentingState.select);
    routePoints.clear();
    moveToSelectedStation();
    update();
  }
  // End Region

  // Region Get Current Location

  Future<void> _getCurrentLocation() async {
    Position currentPosition;
    try {
      currentPosition = await MapUtils.determinePosition();
    } catch (e) {
      return;
    }

    currentLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void _goToCurrentLocationWithZoomDelay({double? zoom}) async {
    if (currentLocation == null) return;
    await Future.delayed(const Duration(milliseconds: 500));
    _moveToPosition(currentLocation!, zoom: zoom ?? zoomInLevel);
  }

  void _goToCurrentLocation({double? zoom}) async {
    if (currentLocation == null) return;
    await _getCurrentLocation();
    _moveToPosition(currentLocation!, zoom: zoom ?? mapController.zoom);
  }

  void goToCurrentLocation() {
    if (rentingState.value == RentingState.navigation) {
      _goToCurrentLocation(zoom: navigationZoomLevel);
    } else {
      _goToCurrentLocation();
    }
  }

  void _moveToPosition(LatLng position, {double? zoom}) {
    if (_animatedMap == null) return;
    var zoomLevel = zoom ?? mapController.zoom;
    _animatedMap!.move(position, zoomLevel);
  }
  // End Region

  // Region Navigation
  PageController pageController = PageController();
  int currentLegIndex = 0;
  var isFlowingMode = true.obs;

  Rx<List<LatLng>> legPolyLine = Rx<List<LatLng>>([]);
  bool isAnimatedToPage = false;

  void goToNavigation() async {
    _changeRentingState(RentingState.navigation);
    await _getCurrentLocation();
    positionStream?.resume();
    _goToCurrentLocation(zoom: navigationZoomLevel);
    update();
  }

  void goToCurrentLeg() async {
    await _getCurrentLocation();
    _goToCurrentLocation(zoom: navigationZoomLevel);

    isFlowingMode.value = true;
    positionStream?.resume();

    legPolyLine([]);

    isAnimatedToPage = true;
    await pageController.animateToPage(
      currentLegIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    isAnimatedToPage = false;

    update();
  }

  void _centerZoomFitLegBounds() {
    LatLngBounds bounds = LatLngBounds();
    for (LatLng point in legPolyLine.value) {
      bounds.extend(point);
    }
    bounds.pad(0.52);
    _centerZoomFitBounds(bounds);
  }

  void _loadCurrentLegPolyline(int index) {
    String polylineCode = legs?.steps?[index].polyline?.points ?? '';
    legPolyLine(PolyLatLng.decode(polylineCode));
    _centerZoomFitLegBounds();
  }

  void onPageChanged(int index) {
    if (isAnimatedToPage) {
      return;
    }

    _loadCurrentLegPolyline(index);
    isFlowingMode.value = false;
    positionStream?.pause();

    update();
  }

  void goBackFromNavigation() {
    _changeRentingState(RentingState.route);
    _centerZoomFitBounds(currentBounds!);
    update();
  }

  void _centerZoomFitBounds(LatLngBounds bounds) {
    if (_animatedMap == null) return;
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    _animatedMap!.move(centerZoom.center, centerZoom.zoom);
  }
  // End Region

  // Region Station Selector
  void _selectStatiton(String stationId) {
    _changeRentingState(RentingState.select);
    selectedStationId = stationId;
  }

  void unfocus() {
    _changeRentingState(RentingState.normal);
    selectedStationId = null;
    update();
  }

  void moveToSelectedStation() {
    if (selectedStation == null) return;

    double lat = selectedStation?.latitude ?? 0;
    double lng = selectedStation?.longitude ?? 0;

    var location = LatLng(lat, lng);
    _moveToPosition(location);
  }

  void _changeRentingState(RentingState state) {
    _updateMarker();
    rentingState.value = state;
  }
  // End Region

  StreamSubscription<Position>? positionStream;
  LocationSettings? locationSettings;

  void _locationListener() {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      forceLocationManager: true,
      //(Optional) Set foreground notification config to keep the app alive
      //when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      ),
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) async {
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');

        if (rentingState.value == RentingState.navigation &&
            isFlowingMode.value) {
          await _getCurrentLocation();
          _goToCurrentLocation(zoom: navigationZoomLevel);

          _getSelectedLegIndex(position?.latitude, position?.longitude);
        }
      },
    );
  }

  _getSelectedLegIndex(double? lat, double? lng) {
    List<Steps>? steps = legs?.steps;
    int length = steps?.length ?? 0;

    mt.LatLng currentLocation = mt.LatLng(lat ?? 0, lng ?? 0);
    double minDistance = double.infinity;

    if (steps == null || lat == null || lng == null) return;

    int result = length - 1;
    for (int i = length - 1; i >= 0; i--) {
      var step = steps[i];
      mt.LatLng start =
          mt.LatLng(step.startLocation?.lat ?? 0, step.startLocation?.lng ?? 0);
      mt.LatLng end =
          mt.LatLng(step.startLocation?.lat ?? 0, step.startLocation?.lng ?? 0);

      var startDistance =
          mt.SphericalUtil.computeDistanceBetween(currentLocation, start);
      var endDistance =
          mt.SphericalUtil.computeDistanceBetween(currentLocation, end);

      if (startDistance < minDistance || endDistance < minDistance) {
        var min = startDistance < endDistance ? startDistance : endDistance;
        minDistance = min.toDouble();
        result = i;
      }
    }

    selectedLegIndex.value = result;
    debugPrint('Nam: $result');
  }

  void resumeStream() {
    positionStream?.resume();
  }
}
