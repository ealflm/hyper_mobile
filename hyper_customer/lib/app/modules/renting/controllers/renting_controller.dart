import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/core/utils/polylatlng_utils.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/constants/renting_constant.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_map_controller.dart';
import 'package:hyper_customer/app/modules/renting/models/renting_state.dart';

import 'package:latlong2/latlong.dart';

class RentingController extends BaseController
    with GetTickerProviderStateMixin {
  // Region Repository
  final Repository _repository = Get.find(tag: (Repository).toString());
  final MapboxRepository _mapboxRepository =
      Get.find(tag: (MapboxRepository).toString());
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());
  // End Region

  // Region Controller
  MapController mapController = MapController();
  late AnimatedMapController _animatedMapController;
  late MapLocationController _mapLocationController;
  late RentingMapController _rentingMapController;
  // End Region

  LatLngBounds? currentBounds;

  RentStations? rentStations;
  List<Widget> searchItems = [];

  String? selectedStationId;
  Items? get selectedStation => rentStationMap[selectedStationId];

  var rentingState = RentingState.normal.obs;

  // Region Init
  @override
  void onInit() async {
    init();
    super.onInit();
  }

  Future<void> init() async {
    _animatedMapController =
        AnimatedMapController(controller: mapController, vsync: this);

    _mapLocationController = MapLocationController();
    _mapLocationController.init();

    _rentingMapController =
        RentingMapController(mapController, _animatedMapController);

    await _fetchRentStations();
    _goToCurrentLocationWithZoomDelay();
  }
  // End Region

  // Region Fetch Rent Stations
  List<Marker> markers = [];
  Map<String, Items> rentStationMap = {};

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
    _updateRentStationMap();
  }

  void _updateRentStationMap() {
    rentStationMap.clear();
    var items = rentStations?.body?.items ?? [];
    for (Items item in items) {
      var itemId = item.id ?? '';
      rentStationMap[itemId] = item;
    }
  }

  void _updateMarker() {
    markers.clear();
    rentStationMap.clear();

    var items = rentStations?.body?.items ?? [];
    for (Items item in items) {
      double lat = item.latitude ?? 0;
      double lng = item.longitude ?? 0;

      var itemId = item.id ?? '';
      var location = LatLng(lat, lng);

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
  Legs? legs;
  var selectedLegIndex = 0.obs;

  void fetchGoongRoute() async {
    isFindingRoute.value = true;

    routePoints.clear();

    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

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

  void _goToCurrentLocationWithZoomDelay({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await Future.delayed(const Duration(milliseconds: 500));
    _moveToPosition(currentLocation!,
        zoom: zoom ?? RentingConstant.focusZoomLevel);
  }

  void _goToCurrentLocation({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await _mapLocationController.loadLocation();

    _moveToPosition(currentLocation!, zoom: zoom ?? mapController.zoom);
  }

  void goToCurrentLocation() {
    if (rentingState.value == RentingState.navigation) {
      _goToCurrentLocation(zoom: RentingConstant.navigationModeZoomLevel);
    } else {
      _goToCurrentLocation();
    }
  }

  void _moveToPosition(LatLng position, {double? zoom}) {
    var zoomLevel = zoom ?? mapController.zoom;
    _animatedMapController.move(position, zoomLevel);
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

    await _mapLocationController.loadLocation();

    _goToCurrentLocation(zoom: RentingConstant.navigationModeZoomLevel);
    update();
  }

  void goToCurrentLeg() async {
    await _mapLocationController.loadLocation();

    _goToCurrentLocation(zoom: RentingConstant.navigationModeZoomLevel);

    isFlowingMode.value = true;

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

    update();
  }

  void goBackFromNavigation() {
    _changeRentingState(RentingState.route);
    _centerZoomFitBounds(currentBounds!);
    update();
  }

  void _centerZoomFitBounds(LatLngBounds bounds) {
    var centerZoom = mapController.centerZoomFitBounds(bounds);
    _animatedMapController.move(centerZoom.center, centerZoom.zoom);
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

}
