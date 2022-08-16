import 'package:get/get.dart';

import '../controllers/booking_request_controller.dart';

class BookingRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingRequestController>(
      () => BookingRequestController(),
    );
  }
}
