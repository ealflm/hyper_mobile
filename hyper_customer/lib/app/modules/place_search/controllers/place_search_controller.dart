import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/models/place_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/modules/place_search/widgets/search_item.dart';
import 'package:hyper_customer/app/routes/app_pages.dart' as app;
import 'package:latlong2/latlong.dart';

class PlaceSearchController extends BaseController {
  final GoongRepository _repository =
      Get.find(tag: (GoongRepository).toString());

  String? initialText;

  TextEditingController editingController = TextEditingController();

  Place? searchPlace;
  List<Predictions> predictions = [];

  Rx<List<Widget>> searchItems = Rx<List<Widget>>([]);
  Timer? _debounce;

  MapLocationController locationController = MapLocationController();

  var allowMyLocation = true.obs;
  PlaceDetail? anchorPlace;

  @override
  onInit() {
    locationController.init();

    var arg = Get.arguments;
    initialText = arg['initialText'];
    allowMyLocation.value = arg['allowMyLocation'] ?? true;
    anchorPlace = arg['anchorPlace'];

    if (initialText != null) {
      editingController.text = initialText!;
      onSearchChanged(initialText!);
    }
    super.onInit();
  }

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 100),
      () {
        search(query);
      },
    );
  }

  void search(String query) async {
    var searchService = _repository.search(query);

    await callDataService(
      searchService,
      onSuccess: (Place response) {
        searchPlace = response;
      },
      onError: (DioError dioError) {
        // Utils.showToast('Kết nối thất bại');
      },
    );

    predictions = searchPlace?.predictions ?? [];
    List<Widget> result = [];

    for (Predictions item in predictions) {
      if (item.compound?.district == 'Phú Quốc' ||
          (item.description ?? '').contains('Phú Quốc')) {
        result.add(
          SearchItem(
            title: item.structuredFormatting?.mainText ?? '-',
            description: item.structuredFormatting?.secondaryText ?? '-',
            onPressed: () {
              selectPlace(item.placeId ?? '');
            },
          ),
        );
      }
    }

    searchItems(result);
  }

  void clearSearchItems() {
    searchItems([]);
  }

  void selectPlace(String id) async {
    PlaceDetail? selectedPlace;
    var placeDetailService = _repository.getPlaceDetail(id);
    await callDataService(
      placeDetailService,
      onSuccess: (PlaceDetail response) {
        selectedPlace = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    var canGo = await checkAnchor(selectedPlace);
    if (!canGo) return;

    if (selectedPlace != null) {
      Get.back(result: selectedPlace);
    }
  }

  void selectMyLocation() async {
    PlaceDetail? selectedPlace;
    LatLng? myLocation = locationController.location;
    if (myLocation != null) {
      selectedPlace = PlaceDetail(
        placeId: '-',
        formattedAddress: AppValues.myLocation,
        name: AppValues.myLocation,
        geometry: Geometry(
          location: Location(
            lat: myLocation.latitude,
            lng: myLocation.longitude,
          ),
        ),
      );

      var canGo = await checkAnchor(selectedPlace);
      if (!canGo) return;

      Get.back(result: selectedPlace);
    }
  }

  void selectOnMap() async {
    PlaceDetail? selectedPlace;
    var data = await Get.toNamed(app.Routes.SELECT_ON_MAP);
    if (data != null) {
      selectedPlace = data;

      var canGo = await checkAnchor(selectedPlace);
      if (!canGo) return;

      Get.back(result: selectedPlace);
    }
  }

  Future<bool> checkAnchor(PlaceDetail? selectedPlace) async {
    if (anchorPlace != null) {
      var start = LatLng(
        anchorPlace?.geometry?.location?.lat ?? 0,
        anchorPlace?.geometry?.location?.lng ?? 0,
      );
      var end = LatLng(
        selectedPlace?.geometry?.location?.lat ?? 0,
        selectedPlace?.geometry?.location?.lng ?? 0,
      );

      var directionService = _repository.findRoute(start, end);

      Directions? directions;

      await callDataService(
        directionService,
        onSuccess: (Directions response) {
          directions = response;
        },
        onError: (DioError dioError) {
          // Utils.showToast('Kết nối thất bại');
        },
      );

      if (directions == null) return false;

      int distance = directions?.routes?[0].legs?[0].distance?.value ?? 0;

      if (distance <= 1000) {
        Utils.showToast('Khoản cách giữa điểm đi và điểm đến phải lớn hơn 1km');
        return false;
      }
    }
    return true;
  }
}
