import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/bus_station_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/bus_item.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/walk_item.dart';
import 'package:hyper_customer/app/modules/bus_payment/controllers/bus_payment_controller.dart';
import 'package:hyper_customer/app/modules/bus_payment/models/state.dart';
import 'package:hyper_customer/app/modules/scan/models/scan_mode.dart';
import 'package:latlong2/latlong.dart';

import '../../../routes/app_pages.dart';

class BusDirectionController extends BaseController {
  final MapboxRepository _repository =
      Get.find(tag: (MapboxRepository).toString());

  final BusPaymentController _busPaymentController =
      Get.find<BusPaymentController>();

  HyperMapController mapController = HyperMapController();
  late BusStationController busStationController;

  BusDirection? busDirection;
  PlaceDetail? endPlace;

  var isExpanded = true.obs;

  Rx<List<Widget>> directions = Rx<List<Widget>>([]);
  Rx<List<Widget>> polylines = Rx<List<Widget>>([]);

  var currentIndex = 0.obs;

  Rx<LatLng?> startMarker = Rx<LatLng?>(null);
  Rx<LatLng?> endMarker = Rx<LatLng?>(null);

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    busDirection = Get.arguments['busDirection'];
    endPlace = Get.arguments['endPlace'];
    loadBusDirection();
    _loadDestinationMarker();
    busStationController = BusStationController(mapController);
    List<Steps> steps = busDirection?.steps ?? [];
    if (steps.isEmpty) return;
    busStationController.selectBusStation(steps[0].stationList?.last.id);
  }

  void loadBusDirection() async {
    if (busDirection == null || endPlace == null) return;

    _loadIndex();
    _loadDirections();
    await _loadPolylines();
    _loadSelectedPolylines();
    centerZoomSelectedBounds();
  }

  void _loadIndex() {
    List<Steps> steps = busDirection?.steps ?? [];

    for (int i = 0; i < steps.length; i++) {
      var item = steps[i];
      item.index = i;
    }
  }

  void _changeIndex(int index, Steps item) {
    currentIndex.value = index;
    _loadDirections();
    _loadSelectedPolylines();
    centerZoomSelectedBounds();
    busStationController.selectBusStation(item.stationList?.last.id);
  }

  void _loadDestinationMarker() {
    if (endPlace == null) return;
    LatLng location = LatLng(
      endPlace?.geometry?.location?.lat ?? 0,
      endPlace?.geometry?.location?.lng ?? 0,
    );
    endMarker(location);
  }

  void centerZoomFullBounds() {
    var bounds = LatLngBounds();
    List<Steps> steps = busDirection?.steps ?? [];

    for (var item in steps) {
      if (item.latLngList == null) return;
      for (var point in item.latLngList ?? []) {
        bounds.extend(point);
      }
    }

    bounds.pad(0.3);
    mapController.centerZoomFitBounds(bounds);
  }

  void _loadDirections() {
    List<Widget> result = [];
    List<Steps> steps = busDirection?.steps ?? [];

    for (Steps item in steps) {
      if (item.name == 'Đi bộ') {
        WalkItem walkItem = WalkItem(
          destination: item.stationList?[1].title ?? endPlace?.name ?? '-',
          distance: item.distance?.toInt() ?? 0,
          isSelected: item.index == currentIndex.value,
          onPressed: () {
            _changeIndex(item.index ?? 0, item);
          },
        );
        result.add(walkItem);
      } else {
        BusItem busItem = BusItem(
          tripName: item.name ?? '-',
          destination: item.stationList?.last.title ?? '-',
          distance: item.distance?.toInt() ?? 0,
          isSelected: item.index == currentIndex.value,
          onPressed: () {
            _changeIndex(item.index ?? 0, item);
          },
        );
        result.add(busItem);
      }
    }
    directions(result);
  }

  Rx<Widget?> selectedPolylines = Rx<Widget?>(null);

  void _loadSelectedPolylines() {
    Widget? result;
    List<Steps> steps = busDirection?.steps ?? [];

    for (Steps item in steps) {
      if (item.index == currentIndex.value) {
        if (item.name == 'Đi bộ') {
          result = PolylineLayerWidget(
            options: PolylineLayerOptions(
              polylines: [
                Polyline(
                  strokeWidth: 4.r,
                  // color: AppColors.blue,
                  gradientColors: [
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleEnd,
                  ],
                  borderStrokeWidth: 3.r,
                  borderColor: AppColors.white,
                  isDotted: true,
                  points: item.latLngList ?? [],
                )
              ],
            ),
          );
        } else {
          result = PolylineLayerWidget(
            options: PolylineLayerOptions(
              polylines: [
                Polyline(
                  strokeWidth: 4.r,
                  // color: AppColors.blue,
                  gradientColors: [
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleStart,
                    AppColors.purpleEnd,
                  ],
                  borderStrokeWidth: 3.r,
                  borderColor: AppColors.white,
                  points: item.latLngList ?? [],
                ),
              ],
            ),
          );
        }
        startMarker(item.latLngList?.first);
        // endMarker(item.latLngList?.last);
      }
    }
    selectedPolylines(result);
  }

  void centerZoomSelectedBounds() {
    var bounds = LatLngBounds();
    List<Steps> steps = busDirection?.steps ?? [];

    for (var item in steps) {
      if (item.index == currentIndex.value) {
        if (item.latLngList == null) return;
        for (var point in item.latLngList ?? []) {
          bounds.extend(point);
        }
      }
    }

    bounds.pad(0.2);
    mapController.centerZoomFitBounds(bounds);
  }

  Future<void> _loadPolylines() async {
    List<Widget> polylineResult = [];
    List<Steps> steps = busDirection?.steps ?? [];

    for (Steps item in steps) {
      item.latLngList = await fetchPolylines(item);
      Widget polylineWidget;
      if (item.name == 'Đi bộ') {
        polylineWidget = PolylineLayerWidget(
          options: PolylineLayerOptions(
            polylines: [
              Polyline(
                strokeWidth: 3.r,
                color: AppColors.caption,
                borderStrokeWidth: 2.r,
                borderColor: AppColors.gray,
                isDotted: true,
                points: item.latLngList ?? [],
              ),
            ],
          ),
        );
      } else {
        polylineWidget = PolylineLayerWidget(
          options: PolylineLayerOptions(
            polylines: [
              Polyline(
                strokeWidth: 3.r,
                color: AppColors.caption,
                borderStrokeWidth: 2.r,
                borderColor: AppColors.gray,
                points: item.latLngList ?? [],
              ),
            ],
          ),
        );
      }
      polylineResult.add(polylineWidget);
    }
    polylines(polylineResult);
  }

  void goToCurrentLocation({double? zoom}) async {
    mapController.moveToCurrentLocation();
  }

  void toggleExpand() async {
    isExpanded.value = !isExpanded.value;
  }

  Future<List<LatLng>?> fetchPolylines(Steps steps) async {
    if (steps.stationList == null) return null;
    List<LatLng>? result;
    List<LatLng> points = [];
    for (var item in steps.stationList!) {
      if (item.latitude == null || item.longitude == null) return null;
      points.add(LatLng(item.latitude ?? 0, item.longitude ?? 0));
    }

    var directionService = _repository.findRoute(points);

    await callDataService(
      directionService,
      onSuccess: (List<LatLng> response) {
        result = response;
      },
      onError: (DioError dioError) {},
    );

    return result;
  }

  void getToScanView() async {
    var data = await Get.toNamed(
      Routes.SCAN,
      arguments: {
        'scanMode': ScanMode.busing,
      },
    );
    if (data == null) return;
    String code = data['code'] ?? '';
    _busPaymentController.code = code;
    HyperDialog.showLoading(
      title: 'Thanh toán vé xe buýt',
      primaryButtonText: 'OK',
    );
    await _busPaymentController.busPayment();
    if (HyperDialog.isOpen) Get.back();
    if (_busPaymentController.state.value == ViewState.success) {
      HyperDialog.showSuccess(
        title: 'Thanh toán vé xe buýt',
        primaryButtonText: 'OK',
      );
    } else {
      HyperDialog.showFail(
        title: 'Thanh toán vé xe buýt',
        primaryButtonText: 'OK',
      );
    }
  }
}
