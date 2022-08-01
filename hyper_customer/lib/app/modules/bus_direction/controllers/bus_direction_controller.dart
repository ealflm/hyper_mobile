import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/bus_item.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/walk_item.dart';
import 'package:latlong2/latlong.dart';

class BusDirectionController extends BaseController {
  final MapboxRepository _repository =
      Get.find(tag: (MapboxRepository).toString());

  HyperMapController mapController = HyperMapController();

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

  void _changeIndex(int index) {
    currentIndex.value = index;
    _loadDirections();
    _loadSelectedPolylines();
    centerZoomSelectedBounds();
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

    bounds.pad(0.1);
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
            _changeIndex(item.index ?? 0);
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
            _changeIndex(item.index ?? 0);
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
                  color: AppColors.blue,
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
                  color: AppColors.blue,
                  borderStrokeWidth: 3.r,
                  borderColor: AppColors.white,
                  points: item.latLngList ?? [],
                ),
              ],
            ),
          );
        }
        startMarker(item.latLngList?.first);
        endMarker(item.latLngList?.last);
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

    bounds.pad(0.1);
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
                color: AppColors.indicator,
                borderStrokeWidth: 2.r,
                borderColor: AppColors.caption,
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
                color: AppColors.indicator,
                borderStrokeWidth: 2.r,
                borderColor: AppColors.caption,
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
}
