import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_search_controller.dart';
import 'package:hyper_customer/app/modules/renting/controllers/zoom_button_controller.dart';

import '../controllers/renting_controller.dart';

class RentingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentingController>(
      () => RentingController(),
    );
    Get.lazyPut<RentingSearchController>(
      () => RentingSearchController(),
    );
    Get.lazyPut<ZoomButtonController>(
      () => ZoomButtonController(),
      fenix: true,
    );
  }
}
