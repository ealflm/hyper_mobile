import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class BusingController extends BaseController {
  TextEditingController startTextEditingController = TextEditingController();
  Rx<PlaceDetail> startPlace = Rx<PlaceDetail>(PlaceDetail());

  TextEditingController endTextEditingController = TextEditingController();
  Rx<PlaceDetail> endPlace = Rx<PlaceDetail>(PlaceDetail());

  bool get canSwap {
    return startPlace.value.placeId != null && endPlace.value.placeId != null;
  }

  void startTextFieldOnPressed() async {
    var data = await Get.toNamed(
      Routes.PLACE_SEARCH,
      arguments: {
        'initialText': startPlace.value.name ?? '',
        'allowMyLocation': !(endPlace.value.name == AppValues.myLocation),
      },
    );
    if (data != null) {
      startPlace(data);
      startTextEditingController.text = data.formattedAddress;
    }
  }

  void endTextFieldOnPressed() async {
    var data = await Get.toNamed(
      Routes.PLACE_SEARCH,
      arguments: {
        'initialText': endPlace.value.name ?? '',
        'allowMyLocation': !(startPlace.value.name == AppValues.myLocation),
      },
    );
    if (data != null) {
      endPlace(data);
      endTextEditingController.text = data.formattedAddress;
    }
  }

  void swap() {
    var temp = startPlace;
    startPlace = endPlace;
    endPlace = temp;
    endTextEditingController.text = endPlace.value.formattedAddress ?? '';
    startTextEditingController.text = startPlace.value.formattedAddress ?? '';
  }
}
