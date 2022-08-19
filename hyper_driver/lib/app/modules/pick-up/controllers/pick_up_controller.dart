import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/data/repository/goong_repository.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';

class PickUpController extends BaseController {
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  var state = PickUpState.came.obs;

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  void init() async {}

  // End Region

  // Region Change State

  void changeState(PickUpState value) {
    state.value = value;
  }

  // End Region

}
