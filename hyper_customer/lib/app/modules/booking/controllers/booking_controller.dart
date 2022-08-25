import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/busing/widgets/search_item.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';

class BookingController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  HyperMapController mapController = HyperMapController();

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

  var isLoadingPage = false.obs;

  bool get canSwap {
    return startPlace.value.placeId != null && endPlace.value.placeId != null;
  }

  @override
  void onInit() {
    SignalR.instance.start();
    super.onInit();
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
  }

  void centerZoomFitBounds() {
    if (startPlace.value.placeId == null && endPlace.value.placeId == null) {
      return;
    }

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

    mapController.centerZoomFitBounds(bounds);
  }

  void focusOnStartPlace() {
    var startlocation = LatLng(
      startPlace.value.geometry?.location?.lat ?? 0,
      startPlace.value.geometry?.location?.lng ?? 0,
    );

    mapController.moveToPosition(startlocation, zoom: AppValues.focusZoomLevel);
  }

  void focusOnEndPlace() {
    var startlocation = LatLng(
      endPlace.value.geometry?.location?.lat ?? 0,
      endPlace.value.geometry?.location?.lng ?? 0,
    );

    mapController.moveToPosition(startlocation, zoom: AppValues.focusZoomLevel);
  }

  void goToCurrentLocation({double? zoom}) async {
    mapController.moveToCurrentLocation();
  }

  List<BusDirection> busDirectionList = [];
  Rx<List<SearchItem>> searchItemList = Rx<List<SearchItem>>([]);

  void getToBookingDirection() async {
    isLoadingPage.value = true;
    if (startPlaceLocation == null || endPlaceLocation == null) {
      Utils.showToast('Vui lòng chọn điểm đi và điểm đến');
      isLoadingPage.value = false;
      return;
    }
    Get.toNamed(Routes.BOOKING_DIRECTION, arguments: {
      'startPlace': startPlace.value,
      'endPlace': endPlace.value,
    });
    isLoadingPage.value = false;
  }
}
