import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_search_route_controller.dart';

import '../controllers/busing_controller.dart';

class BusingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusingController>(
      () => BusingController(),
    );
    Get.lazyPut<BusingSearchRouteController>(
      () => BusingSearchRouteController(),
    );
  }
}
