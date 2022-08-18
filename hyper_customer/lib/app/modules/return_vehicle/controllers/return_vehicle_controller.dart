import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/return_vehicle/models/state.dart';

class ReturnVehicleController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code;
  String? customerTripId;
  var state = ViewState.loading.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('code') && data.containsKey('customerTripId')) {
        code = Get.arguments['code'];
        customerTripId = Get.arguments['customerTripId'];
        returnVehicle();
      } else {
        state.value = ViewState.error;
      }
    }
    super.onInit();
  }

  Future<void> returnVehicle() async {
    state.value = ViewState.loading;

    if (customerTripId == null || code == null) {
      state.value = ViewState.error;
      return;
    }

    var returnVehicleService =
        _repository.returnVehicle(code!, customerTripId!);

    await callDataService(
      returnVehicleService,
      onSuccess: (bool response) {
        state.value = response ? ViewState.success : ViewState.error;
      },
      onError: (DioError dioError) {
        state.value = ViewState.error;
      },
    );
  }
}
