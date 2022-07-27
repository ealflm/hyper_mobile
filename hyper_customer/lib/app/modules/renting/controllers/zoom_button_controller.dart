import 'package:get/get.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_controller.dart';

class ZoomButtonController extends GetxController {
  final RentingController _rentingController = Get.find<RentingController>();
  var state = ZoomButtonState.zoomIn.obs;

  void zoomIn() {
    state.value = ZoomButtonState.zoomIn;
    _rentingController.goToCurrentLocation();
  }

  void zoomOut() {
    state.value = ZoomButtonState.zoomOut;
    _rentingController.centerZoomFitBounds();
  }

  void click() {
    _rentingController.pausePositionStream();
    _rentingController.isFlowingMode.value = false;
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
