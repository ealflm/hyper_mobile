import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:latlong2/latlong.dart';

import '../models/state.dart';

class BusPaymentController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  var state = ViewState.loading.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      code = Get.arguments['code'];
      busPayment();
    }
    super.onInit();
  }

  Future<void> busPayment() async {
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
        // Utils.showToast('Kết nối thất bại');
      },
    );
  }
}
