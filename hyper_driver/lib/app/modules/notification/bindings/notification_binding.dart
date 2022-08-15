import 'package:get/get.dart';
import 'package:hyper_driver/app/modules/notification/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
