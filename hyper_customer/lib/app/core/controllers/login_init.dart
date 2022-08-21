import 'package:hyper_customer/app/core/controllers/notification_controller.dart';
import 'package:hyper_customer/app/network/signalr.dart';

void loginInit() {
  NotificationController.instance.registerNotification();
  SignalR.instance.init();
}
