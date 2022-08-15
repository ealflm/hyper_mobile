import 'package:get/get.dart';
import 'package:hyper_driver/app/modules/renting_form/controllers/renting_day_count_controller.dart';
import 'package:hyper_driver/app/modules/renting_form/controllers/renting_hour_count_controller.dart';

import '../controllers/renting_form_controller.dart';

class RentingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentingFormController>(
      () => RentingFormController(),
    );
    Get.lazyPut<RentingDayCountController>(
      () => RentingDayCountController(),
    );
    Get.lazyPut<RentingHourCountController>(
      () => RentingHourCountController(),
    );
  }
}
