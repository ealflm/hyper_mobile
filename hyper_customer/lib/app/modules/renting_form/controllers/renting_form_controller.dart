import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/data/models/vehicle_rental_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting_form/models/view_state.dart';

class RentingFormController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  ViewState state = ViewState.loading;
  var tabIndex = 0.obs;

  VehicleRental? vehicleRental;

  @override
  void onInit() {
    if (Get.arguments != null) {
      code = Get.arguments['code'];
      _fetchVehicleRental();
    }
    super.onInit();
  }

  _fetchVehicleRental() async {
    var cardLinkService = _repository.getVehicleRental(code ?? '');

    await callDataService(
      cardLinkService,
      onSuccess: (VehicleRental response) {
        vehicleRental = response;
        state = ViewState.successful;
      },
      onError: (DioError dioError) {
        state = ViewState.failed;
      },
    );
    update();
  }
}
