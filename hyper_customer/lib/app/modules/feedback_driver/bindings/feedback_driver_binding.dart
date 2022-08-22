import 'package:get/get.dart';

import '../controllers/feedback_driver_controller.dart';

class FeedbackDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackDriverController>(
      () => FeedbackDriverController(),
    );
  }
}
