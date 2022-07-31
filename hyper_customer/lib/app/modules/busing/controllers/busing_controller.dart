import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/busing/widgets/search_item.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_map_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';

class BusingController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  MapController mapController = MapController();
  late MapLocationController _mapLocationController;
  late MapMoveController _mapMoveController;

  TextEditingController startTextEditingController = TextEditingController();
  Rx<PlaceDetail> startPlace = Rx<PlaceDetail>(PlaceDetail());

  TextEditingController endTextEditingController = TextEditingController();
  Rx<PlaceDetail> endPlace = Rx<PlaceDetail>(PlaceDetail());

  LatLng? get startPlaceLocation {
    if (startPlace.value.placeId == null) return null;
    return LatLng(
      startPlace.value.geometry?.location?.lat ?? 0,
      startPlace.value.geometry?.location?.lng ?? 0,
    );
  }

  LatLng? get endPlaceLocation {
    if (endPlace.value.placeId == null) return null;
    return LatLng(
      endPlace.value.geometry?.location?.lat ?? 0,
      endPlace.value.geometry?.location?.lng ?? 0,
    );
  }

  var searchMode = false.obs;
  var isLoadingPage = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    AnimatedMapController.init(controller: mapController);
    _mapMoveController = MapMoveController(mapController);
    _mapLocationController = MapLocationController();
    await _mapLocationController.init();
  }

  bool get canSwap {
    return startPlace.value.placeId != null && endPlace.value.placeId != null;
  }

  void startTextFieldOnPressed() async {
    var data = await Get.toNamed(
      Routes.PLACE_SEARCH,
      arguments: {
        'initialText': startPlace.value.name ?? '',
        'allowMyLocation': !(endPlace.value.name == AppValues.myLocation),
        'anchorPlace': endPlace.value.placeId != null ? endPlace.value : null,
      },
    );
    if (data != null) {
      startPlace(data);
      startTextEditingController.text = data.formattedAddress;
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      centerZoomFitBounds();
      searchMode.value = false;
    }
  }

  void endTextFieldOnPressed() async {
    var data = await Get.toNamed(
      Routes.PLACE_SEARCH,
      arguments: {
        'initialText': endPlace.value.name ?? '',
        'allowMyLocation': !(startPlace.value.name == AppValues.myLocation),
        'anchorPlace':
            startPlace.value.placeId != null ? startPlace.value : null,
      },
    );
    if (data != null) {
      endPlace(data);
      endTextEditingController.text = data.formattedAddress;
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      centerZoomFitBounds();
      searchMode.value = false;
    }
  }

  void swap() {
    var temp = startPlace;
    startPlace = endPlace;
    endPlace = temp;
    startPlace.update((value) {});
    endPlace.update((value) {});
    endTextEditingController.text = endPlace.value.formattedAddress ?? '';
    startTextEditingController.text = startPlace.value.formattedAddress ?? '';
    centerZoomFitBounds();
    searchMode.value = false;
  }

  void centerZoomFitBounds() {
    if (startPlace.value.placeId == null && endPlace.value.placeId == null) {
      return;
    }

    AnimatedMapController.init(controller: mapController);
    var bounds = LatLngBounds();

    if (startPlace.value.placeId != null && endPlace.value.placeId == null) {
      focusOnStartPlace();
      return;
    }

    if (startPlace.value.placeId == null && endPlace.value.placeId != null) {
      focusOnEndPlace();
      return;
    }

    if (startPlace.value.placeId != null) {
      bounds.extend(
        LatLng(
          startPlace.value.geometry?.location?.lat ?? 0,
          startPlace.value.geometry?.location?.lng ?? 0,
        ),
      );
    }

    if (endPlace.value.placeId != null) {
      bounds.extend(
        LatLng(
          endPlace.value.geometry?.location?.lat ?? 0,
          endPlace.value.geometry?.location?.lng ?? 0,
        ),
      );
    }

    bounds.pad(0.52);

    _mapMoveController.centerZoomFitBounds(bounds);
  }

  void focusOnStartPlace() {
    var startlocation = LatLng(
      startPlace.value.geometry?.location?.lat ?? 0,
      startPlace.value.geometry?.location?.lng ?? 0,
    );

    _mapMoveController.moveToPosition(startlocation,
        zoom: AppValues.focusZoomLevel);
  }

  void focusOnEndPlace() {
    var startlocation = LatLng(
      endPlace.value.geometry?.location?.lat ?? 0,
      endPlace.value.geometry?.location?.lng ?? 0,
    );

    _mapMoveController.moveToPosition(startlocation,
        zoom: AppValues.focusZoomLevel);
  }

  void goToCurrentLocation({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await _mapLocationController.loadLocation();

    _mapMoveController.moveToPosition(
      currentLocation!,
      zoom: zoom ?? AppValues.focusZoomLevel,
    );
  }

  List<BusDirection> busDirectionList = [];
  Rx<List<SearchItem>> searchItemList = Rx<List<SearchItem>>([]);

  void fetchBusDirection() async {
    isLoadingPage.value = true;
    if (startPlaceLocation == null && endPlaceLocation == null) {
      Utils.showToast('Vui lòng chọn điểm đi và điểm đến');
      isLoadingPage.value = false;
      return;
    }
    var busDirectionService =
        _repository.getBusDirection(startPlaceLocation!, endPlaceLocation!);

    await callDataService(
      busDirectionService,
      onSuccess: (List<BusDirection> response) {
        busDirectionList = response;
      },
      onError: (DioError dioError) {},
    );

    List<SearchItem> result = [];

    for (BusDirection item in busDirectionList) {
      int stationNumber = 0;
      List<Steps> steps = item.steps ?? [];

      for (Steps step in steps) {
        if (step.name != 'Đi bộ') {
          stationNumber++;
        }
      }

      String firstStationName = steps[0].stationList?[1].title ?? '';

      SearchItem searchItem = SearchItem(
        stationNumber: stationNumber,
        firstStationName: firstStationName,
        price: 100000,
        onPressed: () {
          Get.toNamed(
            Routes.BUS_DIRECTION,
            arguments: {
              'busDirection': item,
            },
          );
        },
      );
      result.add(searchItem);
    }

    searchItemList(result);
    isLoadingPage.value = false;
    searchMode.value = true;
  }
}
