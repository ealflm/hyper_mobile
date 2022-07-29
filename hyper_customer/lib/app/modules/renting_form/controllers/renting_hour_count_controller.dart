import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/modules/renting_form/controllers/renting_form_controller.dart';

class RentingHourCountController extends BaseController {
  final RentingFormController _rentingFormController =
      Get.find<RentingFormController>();
  double price = 0;
  final _total = 0.0.obs;
  var isShowHint = false.obs;

  int hourMin = 1;
  int hourMax = 1;

  String get total {
    return NumberUtils.vnd(_total.value * hourNum.value);
  }

  @override
  void onInit() {
    price = _rentingFormController.vehicleRental?.pricePerHour?.toDouble() ?? 0;
    hourMin = _rentingFormController.vehicleRental?.minTime?.toInt() ?? 1;
    hourMax = _rentingFormController.vehicleRental?.maxTime?.toInt() ?? 1;
    _total.value = price;
    super.onInit();
  }

  var hourNum = 1.obs;
  final _dateStartByDay = DateTime.now().obs;
  final _dateEndByDay = DateTime.now().add(const Duration(hours: 1)).obs;

  String dateStartByDay() {
    _dateStartByDay.value = DateTime.now();
    return DateTimeUtils.dateTimeToString(_dateStartByDay.value);
  }

  String dateEndByDay() {
    _dateEndByDay.value = DateTime.now().add(Duration(hours: hourNum.value));
    return DateTimeUtils.dateTimeToString(_dateEndByDay.value);
  }

  void increaseDay() {
    if (hourNum.value == hourMax) {
      isShowHint.value = true;
      update();
      return;
    }
    hourNum.value++;
    update();
  }

  void decreaseDay() {
    if (hourNum.value == hourMin) {
      isShowHint.value = true;
      update();
      return;
    }
    hourNum.value--;
    update();
  }
}
