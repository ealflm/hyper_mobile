import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/data/models/bus_trip_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';

import '../models/state.dart';

class BusPaymentController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  var state = ViewState.loading.obs;
  var fromBusing = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('code')) {
        code = Get.arguments['code'];
        busTripInfo();
      } else {
        state.value = ViewState.error;
      }
      if (data.containsKey('fromBusing')) {
        fromBusing.value = Get.arguments['fromBusing'];
      }
    }
    super.onInit();
  }

  Rx<BusTrip?> busTrip = Rx<BusTrip?>(null);

  Future<void> busTripInfo() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;
    state.value = ViewState.loading;

    var tripInfoService = _repository.getBusTrip(code ?? '', customerId);

    await callDataService(
      tripInfoService,
      onSuccess: (BusTrip response) {
        busTrip(response);
        state.value = ViewState.showInfo;
      },
      onError: (DioError dioError) {
        var response = dioError.response;

        if (response?.statusCode == 404) {
          busPaymentSecond();
        } else {
          state.value = ViewState.error;
        }
      },
    );
  }

  Future<void> busPayment() async {
    state.value = ViewState.loading;

    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;
    MapLocationController locationController = MapLocationController();
    await locationController.init();
    LatLng? location = locationController.location;
    if (location == null) {
      state.value = ViewState.error;
      return;
    }

    var busPaymentService = _repository.busPayment(
      customerId: customerId,
      uid: code ?? '',
      location: location,
    );

    await callDataService(
      busPaymentService,
      onSuccess: (bool response) {
        state.value = response ? ViewState.success : ViewState.error;
      },
      onError: (DioError dioError) {
        state.value = ViewState.error;
      },
    );
  }

  Future<void> busPaymentSecond() async {
    state.value = ViewState.loading;

    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;
    MapLocationController locationController = MapLocationController();
    await locationController.init();
    LatLng? location = locationController.location;
    if (location == null) {
      state.value = ViewState.error;
      return;
    }

    var busPaymentService = _repository.busPayment(
      customerId: customerId,
      uid: code ?? '',
      location: location,
    );

    await callDataService(
      busPaymentService,
      onSuccess: (bool response) {
        state.value = response ? ViewState.done : ViewState.error;
      },
      onError: (DioError dioError) {
        state.value = ViewState.error;
      },
    );
  }
}
