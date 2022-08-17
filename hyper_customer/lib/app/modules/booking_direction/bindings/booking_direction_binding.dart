import 'package:get/get.dart';

import '../controllers/booking_direction_controller.dart';

class BookingDirectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDirectionController>(
      () => BookingDirectionController(),
    );
  }
}
