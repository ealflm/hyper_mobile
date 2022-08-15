import 'package:get/get.dart';
import 'package:hyper_driver/app/modules/renting/controllers/renting_controller.dart';

class ZoomButtonController extends GetxController {
  final RentingController _rentingController = Get.find<RentingController>();
  var state = ZoomButtonState.zoomIn.obs;

  void zoomIn() {
    _rentingController.isOverviewMode = false;
    state.value = ZoomButtonState.zoomIn;
    _rentingController.goToCurrentLocation();
  }

  void zoomOut() {
    _rentingController.isOverviewMode = true;
    state.value = ZoomButtonState.zoomOut;
    _rentingController.centerZoomFitBounds();
  }

  void click() {
    // _rentingController.pausePositionStream();
    // _rentingController.isFlowingMode.value = false;
    if (state.value == ZoomButtonState.zoomIn) {
      zoomOut();
    } else {
      zoomIn();
    }
    update();
  }
}

enum ZoomButtonState {
  zoomIn,
  zoomOut,
}
