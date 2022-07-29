import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/models/vehicle_rental_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting_form/models/view_state.dart';
import 'package:hyper_customer/app/modules/renting_form/widgets/renting_by_day.dart';
import 'package:hyper_customer/app/modules/renting_form/widgets/renting_by_hour.dart';

class RentingFormController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  var state = ViewState.loading.obs;

  VehicleRental? vehicleRental;

  @override
  void onInit() {
    if (Get.arguments != null) {
      code = Get.arguments['code'];
      _fetchVehicleRental();
    }
    modeController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  _fetchVehicleRental() async {
    var cardLinkService = _repository.getVehicleRental(code ?? '');

    await callDataService(
      cardLinkService,
      onSuccess: (VehicleRental response) {
        vehicleRental = response;
        state.value = ViewState.successful;
      },
      onError: (DioError dioError) {
        state.value = ViewState.failed;
      },
    );
  }

  // Region Progress tab
  var tabIndex = 0.obs;

  void changeTab(int index) {
    tabIndex.value = index;
  }

  int getTab() {
    if (!(state.value == ViewState.successful)) {
      return -1;
    }
    return tabIndex.value;
  }

  // End Region

  // Region Tab 2

  late TabController modeController;
  var modeIndex = 0.obs;
  final modes = [
    const Tab(text: 'Theo ngày'),
    const Tab(text: 'Theo giờ'),
  ];

  void changeMode(int index) {
    modeIndex.value = index;
  }

  List<Widget> modesWidget = [
    const RentingByDay(),
    const RentingByHour(),
  ];

  // End Region
}
