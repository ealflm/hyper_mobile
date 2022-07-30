import 'package:get/get.dart';

import '../controllers/place_search_controller.dart';

class PlaceSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceSearchController>(
      () => PlaceSearchController(),
    );
  }
}
