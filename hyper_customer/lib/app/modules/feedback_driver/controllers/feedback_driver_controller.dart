import 'package:get/get.dart';

class FeedbackDriverController extends GetxController {
  Rx<int> feedBackPoint = 0.obs;

  void changePoint(int point) {
    feedBackPoint.value = point;
  }
}
