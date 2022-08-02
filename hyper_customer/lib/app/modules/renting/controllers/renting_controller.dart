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
import 'package:hyper_customer/app/core/utils/map_polyline_utils.dart';
import 'package:hyper_customer/app/core/utils/map_utils.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_map_controller.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_position_stream.dart';
import 'package:hyper_customer/app/modules/renting/models/map_mode.dart';
import 'package:hyper_customer/app/routes/app_pages.dart' as app;

import 'package:latlong2/latlong.dart';

class RentingController extends BaseController with WidgetsBindingObserver {
  // Region Repository
  final Repository _repository = Get.find(tag: (Repository).toString());
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());
  // End Region

  // Region Controller
  late MapController mapController = MapController();
  late MapLocationController _mapLocationController;
  late MapMoveController _mapMoveController;
  late RentingPositionStream _positionStream;
  // End Region

  // Region Init
  @override
  void onInit() async {
    init();
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('Current State = $state');
    if (state == AppLifecycleState.resumed && HyperDialog.isOpen) {
      Get.back();
    }
  }

  Future<void> init() async {
    mapController = MapController();

    AnimatedMapController.init(controller: mapController);

    _mapMoveController = MapMoveController(mapController);

    _mapLocationController = MapLocationController();
    await _mapLocationController.init();

    _positionStream =
        RentingPositionStream(onPositionChanged: _onPositionChanged);

    await _fetchRentStations();
    _goToCurrentLocationWithZoomDelay();
  }
  // End Region

  // Region State
  var mapMode = MapMode.normal.obs;

  void _changeMapMode(MapMode state) {
    if (state == MapMode.navigation) {
      resumePositionStream();
    } else {
      pausePositionStream();
      legPolyLine([]);
    }
    _updateMarker();
    mapMode.value = state;
  }
  // End Region

  // Region Moving

  void _goToCurrentLocationWithZoomDelay({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await Future.delayed(const Duration(milliseconds: 500));
    _mapMoveController.moveToPosition(
      currentLocation!,
      zoom: zoom ?? AppValues.focusZoomLevel,
    );
  }

  void _goToCurrentLocation({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await _mapLocationController.loadLocation();

    _mapMoveController.moveToPosition(
      currentLocation!,
      zoom: zoom ?? mapController.zoom,
    );
  }

  void goToCurrentLocation() {
    if (mapMode.value == MapMode.navigation) {
      _goToCurrentLocation(zoom: AppValues.navigationModeZoomLevel);
    } else {
      _goToCurrentLocation();
    }
  }

  void moveToSelectedStation() {
    if (selectedStation == null) return;

    double lat = selectedStation?.latitude ?? 0;
    double lng = selectedStation?.longitude ?? 0;

    var location = LatLng(lat, lng);
    _mapMoveController.moveToPosition(location);
  }

  // End Region

  // Region Fetch Rent Stations
  String? _selectedStationId;

  Items? get selectedStation => rentStationMap[_selectedStationId];

  RentStations? rentStations;

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

    _updateRentStationMap();
    _updateMarker();
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
                  _mapMoveController.moveToPosition(location);
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
            if (_selectedStationId == itemId) {
              result = Container(
                padding: EdgeInsets.only(bottom: 40.r),
                child: GestureDetector(
                  onTap: () {
                    _selectStatiton(itemId);
                    _mapMoveController.moveToPosition(location);
                    update();
                  },
                  child: mapMode.value == MapMode.navigation
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

  void _selectStatiton(String stationId) {
    _changeMapMode(MapMode.select);
    _selectedStationId = stationId;
  }

  void unfocus() {
    _changeMapMode(MapMode.normal);
    _selectedStationId = null;
    update();
  }

  // End Region

  // Region Fetch Route
  Directions? directions;

  List<LatLng> routePoints = [];
  var isFindingRoute = false.obs;
  LatLngBounds? currentBounds;

  Legs? legs;

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

        routePoints = MapPolylineUtils.decode(overviewPolyline);
      },
      onError: (DioError dioError) {
        isFindingRoute.value = false;
        Utils.showToast('Không tìm thấy đường đi phù hợp');
      },
    );

    centerZoomFitBounds();

    isFindingRoute.value = false;
    _changeMapMode(MapMode.route);
  }

  void centerZoomFitBounds() {
    currentBounds = LatLngBounds();
    for (LatLng point in routePoints) {
      currentBounds?.extend(point);
    }
    currentBounds?.pad(0.52);
    _mapMoveController.centerZoomFitBounds(currentBounds!);
  }

  void clearRoute() {
    _changeMapMode(MapMode.select);
    routePoints.clear();
    moveToSelectedStation();
  }
  // End Region

  // Region Navigation
  PageController pageController = PageController();
  Rx<List<LatLng>> legPolyLine = Rx<List<LatLng>>([]);

  int currentLegIndex = 0;
  var isFlowingMode = true.obs;
  bool isAnimatedToPage = false;
  bool isOverviewMode = false;

  void fromRouteModeToNavigationMode() async {
    _changeMapMode(MapMode.navigation);

    await _mapLocationController.loadLocation();

    _goToCurrentLocation(zoom: AppValues.navigationModeZoomLevel);
    update();
  }

  void goToCurrentLeg() async {
    resumePositionStream();

    await _mapLocationController.loadLocation();

    if (!isOverviewMode) {
      _goToCurrentLocation(zoom: AppValues.navigationModeZoomLevel);
    }

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

  void goToCurrentLegCenter() async {
    resumePositionStream();

    await _mapLocationController.loadLocation();

    isOverviewMode = false;

    _goToCurrentLocation(zoom: AppValues.navigationModeZoomLevel);

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

  void onPageChanged(int index) {
    if (isAnimatedToPage) {
      return;
    }

    pausePositionStream();

    _loadCurrentLegPolyline(index);
    isFlowingMode.value = false;

    update();
  }

  void _loadCurrentLegPolyline(int index) {
    String polylineCode = legs?.steps?[index].polyline?.points ?? '';
    legPolyLine(MapPolylineUtils.decode(polylineCode));
    _centerZoomFitLegBounds();
  }

  void _centerZoomFitLegBounds() {
    LatLngBounds bounds = LatLngBounds();
    for (LatLng point in legPolyLine.value) {
      bounds.extend(point);
    }
    bounds.pad(0.52);
    _mapMoveController.centerZoomFitBounds(bounds);
  }

  void fromNavigationModeToRouteMode() {
    _changeMapMode(MapMode.route);
    _mapMoveController.centerZoomFitBounds(currentBounds!);
    update();
  }
  // End Region

  // Region Position Stream
  void _onPositionChanged() async {
    if (mapMode.value == MapMode.navigation && isFlowingMode.value) {
      await _mapLocationController.loadLocation();
      if (!isOverviewMode) {
        _goToCurrentLocation(zoom: AppValues.navigationModeZoomLevel);
      }

      LatLng currentLocation = _mapLocationController.location!;
      LatLng destination = LatLng(
        selectedStation?.latitude ?? 0,
        selectedStation?.longitude ?? 0,
      );
      double distance = MapUtils.distance(currentLocation, destination);
      debugPrint('Current location to destination: $distance m');

      List<Steps> steps = legs?.steps ?? [];

      for (int i = 0; i < steps.length; i++) {
        String polylineCode = legs?.steps?[i].polyline?.points ?? '';
        List<LatLng> points = MapPolylineUtils.decode(polylineCode);
        if (MapUtils.isInRoute(currentLocation, points)) {
          currentLegIndex = i;
          debugPrint('Nam: Set current leg index: $currentLegIndex');
        }
      }

      goToCurrentLeg();

      if (distance <= 50) {
        await Future.delayed(const Duration(seconds: 2));
        _positionStream.close();
        Get.offAllNamed(app.Routes.RENTING_DESTINATION_ARRIVED);
        debugPrint('Nam: Arrived');
      }
    }
  }

  void pausePositionStream() {
    _positionStream.pausePositionStream();
  }

  void resumePositionStream() {
    _positionStream.resumePositionStream();
  }

  void backButtonPressed() {
    _positionStream.close();
  }
  // End Region
}
