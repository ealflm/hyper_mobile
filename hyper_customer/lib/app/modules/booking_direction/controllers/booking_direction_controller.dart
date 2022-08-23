import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/model/location_model.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/utils/map_polyline_utils.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/booking_price_model.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/vehicle.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';

class BookingDirectionController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  HyperMapController mapController = HyperMapController();

  Rx<PlaceDetail?> startPlace = Rx<PlaceDetail?>(null);
  Rx<PlaceDetail?> endPlace = Rx<PlaceDetail?>(null);

  LatLng? get startPlaceLocation {
    if (startPlace.value?.placeId == null) return null;
    return LatLng(
      startPlace.value?.geometry?.location?.lat ?? 0,
      startPlace.value?.geometry?.location?.lng ?? 0,
    );
  }

  LatLng? get endPlaceLocation {
    if (endPlace.value?.placeId == null) return null;
    return LatLng(
      endPlace.value?.geometry?.location?.lat ?? 0,
      endPlace.value?.geometry?.location?.lng ?? 0,
    );
  }

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void init() async {
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('startPlace')) {
        startPlace.value = data['startPlace'];
      }
      if (data.containsKey('endPlace')) {
        endPlace.value = data['endPlace'];
      }
    }
    if (startPlace.value != null && endPlace.value != null) {
      loadDriverInfos();
      await fetchGoongRoute();
      await fetchPrice();
    } else {
      Utils.showToast('Không có điểm bắt đầu và kết thúc');
    }
  }

  // End Region

  // Region State

  var vehicle = Vehicle.motorcycle.obs;

  void changeVehicle(Vehicle value) {
    vehicle.value = value;
  }

  // End Region

  // Region Fetch Route
  Directions? directions;

  List<LatLng> routePoints = [];
  var isFindingRoute = false.obs;
  LatLngBounds? currentBounds;
  var hasRoute = false.obs;

  Legs? legs;

  Future<void> fetchGoongRoute() async {
    isFindingRoute.value = true;

    routePoints.clear();

    if (startPlaceLocation == null || endPlaceLocation == null) {
      Utils.showToast('Không có điểm đầu và điểm cuối');
    }

    var findRouteService =
        _goongRepository.findRoute(startPlaceLocation!, endPlaceLocation!);

    await callDataService(
      findRouteService,
      onSuccess: (Directions response) {
        directions = response;

        String overviewPolyline =
            directions?.routes?[0].overviewPolyline?.points ?? '';

        legs = directions?.routes?[0].legs?[0];

        routePoints = MapPolylineUtils.decode(overviewPolyline);
        hasRoute.value = true;
      },
      onError: (DioError dioError) {
        isFindingRoute.value = false;
        Utils.showToast('Không tìm thấy đường đi phù hợp');
      },
    );

    isFindingRoute.value = false;
    centerZoomFitBounds();
  }

  void centerZoomFitBounds() {
    currentBounds = LatLngBounds();
    for (LatLng point in routePoints) {
      currentBounds?.extend(point);
    }

    currentBounds?.pad(0.4);
    LatLng? ne = currentBounds?.northEast;
    LatLng? sw = currentBounds?.southWest;
    final heightBuffer = (sw!.latitude - ne!.latitude).abs() * 0.8;
    sw = LatLng(sw.latitude - heightBuffer, sw.longitude);
    currentBounds?.extend(sw);

    mapController.centerZoomFitBounds(currentBounds!);
  }

  void clearRoute() {
    routePoints.clear();
    hasRoute.value = false;
  }

  void focusOnStartPlace() {
    var startlocation = startPlaceLocation ?? LatLng(0, 0);

    mapController.moveToPosition(startlocation, zoom: AppValues.focusZoomLevel);
  }

  void focusOnEndPlace() {
    var endlocation = startPlaceLocation ?? LatLng(0, 0);

    mapController.moveToPosition(endlocation, zoom: AppValues.focusZoomLevel);
  }
  // End Region

  // Region Fetch Price
  Rx<BookingPrice?> motocyclePrice = Rx<BookingPrice?>(null);
  Rx<BookingPrice?> carPrice = Rx<BookingPrice?>(null);

  Rx<bool> isLoadingPrice = false.obs;

  Future<void> fetchPrice() async {
    isLoadingPrice.value = true;
    double distance =
        (directions?.routes?[0].legs?[0].distance?.value)?.toDouble() ?? 0;
    motocyclePrice.value = await getBookingPrice(distance, 2);
    carPrice.value = await getBookingPrice(distance, 4);

    isLoadingPrice.value = false;
  }

  Future<BookingPrice?> getBookingPrice(double distance, int seat) async {
    BookingPrice? result;

    var bookingPriceService = _repository.getBookingPrice(distance, seat);

    await callDataService(
      bookingPriceService,
      onSuccess: (BookingPrice response) {
        result = response;
      },
      onError: (dioError) {},
    );

    return result;
  }

  // End Region

  // Region State Management

  var bookingState = BookingState.select.obs;

  void changeState(BookingState value) {
    bookingState.value = value;
  }

  void lookingForDriver() async {
    changeState(BookingState.finding);
    mapController.moveToCurrentLocation();
    _findDriver();
  }

  void _findDriver() {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    double distance =
        (directions?.routes?[0].legs?[0].distance?.value)?.toDouble() ?? 0;
    LocationModel location = LocationModel(
      id: customerId,
      latitude: startPlaceLocation?.latitude ?? 0.0,
      longitude: startPlaceLocation?.longitude ?? 0.0,
      priceBookingId: motocyclePrice.value?.priceOfBookingServiceId ?? '',
      price: motocyclePrice.value?.totalPrice ?? 0.0,
      distance: distance,
      seats: 2,
    );
    SignalR.instance.findDriver(location);
  }

  // End Region

  // Region SignalR

  Rx<List<LatLng>> driverInfos = Rx<List<LatLng>>([]);
  Rx<List<Marker>> driverMarkers = Rx<List<Marker>>([]);
  Timer? timer;

  void loadDriverInfos() async {
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => fetchDriverInfos(),
    );
  }

  void fetchDriverInfos() async {
    driverInfos.value = await SignalR.instance.getDriverInfos(
      startPlaceLocation ?? LatLng(0, 0),
    );

    List<Marker> markers = [];
    for (LatLng item in driverInfos.value) {
      markers.add(
        Marker(
          point: item,
          width: 18.r,
          height: 18.r,
          builder: (context) => const Icon(Icons.motorcycle),
        ),
      );
    }

    driverMarkers(markers);
  }

  // End Region

}
