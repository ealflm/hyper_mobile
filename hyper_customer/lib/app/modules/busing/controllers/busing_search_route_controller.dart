import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/models/place_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_controller.dart';
import 'package:hyper_customer/app/modules/renting/widgets/search_item.dart';

class BusingSearchRouteController extends BaseController {
  final BusingController _busingController = Get.find<BusingController>();
  final GoongRepository _repository =
      Get.find(tag: (GoongRepository).toString());

  TextEditingController startTextEditingController = TextEditingController();
  TextEditingController endTextEditingController = TextEditingController();
  Rx<PlaceDetail> start = Rx<PlaceDetail>(PlaceDetail());
  Rx<PlaceDetail> end = Rx<PlaceDetail>(PlaceDetail());

  bool get canSwap {
    return start.value.placeId != null && end.value.placeId != null;
  }

  @override
  onClose() {
    _startDebounce?.cancel();
    _endDebounce?.cancel();
    super.onClose();
  }

  void swap() {
    Rx<PlaceDetail> temp = start;
    start = end;
    end = temp;
    endTextEditingController.text = end.value.formattedAddress ?? '';
    startTextEditingController.text = start.value.formattedAddress ?? '';
  }

  // Region Start

  Place? startSearchPlace;
  List<Predictions> startPredictions = [];
  Rx<List<Widget>> startSearchItems = Rx<List<Widget>>([]);
  Timer? _startDebounce;
  TextEditingController startSearchEditingController = TextEditingController();

  startOnSearchChanged(String query) {
    if (_startDebounce?.isActive ?? false) _startDebounce?.cancel();
    _startDebounce = Timer(
      const Duration(milliseconds: 100),
      () {
        startSearch(query);
      },
    );
  }

  void startSearch(String query) async {
    var searchService = _repository.search(query);

    await callDataService(
      searchService,
      onSuccess: (Place response) {
        startSearchPlace = response;
      },
      onError: (DioError dioError) {
        // Utils.showToast('Kết nối thất bại');
      },
    );

    startPredictions = startSearchPlace?.predictions ?? [];
    List<Widget> result = [];

    for (Predictions item in startPredictions) {
      if (item.compound?.district == 'Phú Quốc') {
        result.add(SearchItem(
          title: item.structuredFormatting?.mainText ?? '-',
          description: item.structuredFormatting?.secondaryText ?? '-',
          onPressed: () {
            setStartPlace(item.placeId ?? '');
          },
        ));
      }
    }

    startSearchItems(result);
  }

  void clearStartSearchItems() {
    startSearchItems([]);
  }

  void setStartPlace(String id) async {
    var placeDetailService = _repository.getPlaceDetail(id);
    await callDataService(
      placeDetailService,
      onSuccess: (PlaceDetail response) {
        start(response);
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    if (start.value.placeId != null) {
      startTextEditingController.text = start.value.formattedAddress ?? '';
      Get.back();
    }
  }

  void initStart() {
    startSearchEditingController.text = start.value.name ?? '';
    startSearch(start.value.name ?? '');
  }

  // End Region

  // Region End

  Place? endSearchPlace;
  List<Predictions> endPredictions = [];
  Rx<List<Widget>> endSearchItems = Rx<List<Widget>>([]);
  Timer? _endDebounce;
  TextEditingController endSearchEditingController = TextEditingController();

  endOnSearchChanged(String query) {
    if (_endDebounce?.isActive ?? false) _endDebounce?.cancel();
    _endDebounce = Timer(
      const Duration(milliseconds: 100),
      () {
        endSearch(query);
      },
    );
  }

  void endSearch(String query) async {
    var searchService = _repository.search(query);

    await callDataService(
      searchService,
      onSuccess: (Place response) {
        endSearchPlace = response;
      },
      onError: (DioError dioError) {
        // Utils.showToast('Kết nối thất bại');
      },
    );

    endPredictions = endSearchPlace?.predictions ?? [];
    List<Widget> result = [];

    for (Predictions item in endPredictions) {
      if (item.compound?.district == 'Phú Quốc') {
        result.add(SearchItem(
          title: item.structuredFormatting?.mainText ?? '-',
          description: item.structuredFormatting?.secondaryText ?? '-',
          onPressed: () {
            setEndPlace(item.placeId ?? '');
          },
        ));
      }
    }

    endSearchItems(result);
  }

  void clearEndSearchItems() {
    endSearchItems([]);
  }

  void setEndPlace(String id) async {
    var placeDetailService = _repository.getPlaceDetail(id);
    await callDataService(
      placeDetailService,
      onSuccess: (PlaceDetail response) {
        end(response);
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    if (end.value.placeId != null) {
      endTextEditingController.text = end.value.formattedAddress ?? '';
      Get.back();
    }
  }

  void initEnd() {
    endSearchEditingController.text = end.value.name ?? '';
    endSearch(end.value.name ?? '');
  }

  // End Region

}
