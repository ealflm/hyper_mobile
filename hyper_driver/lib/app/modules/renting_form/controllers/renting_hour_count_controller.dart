import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';
import 'package:hyper_driver/app/modules/renting_form/controllers/renting_form_controller.dart';

class RentingHourCountController extends BaseController {
  final RentingFormController _rentingFormController =
      Get.find<RentingFormController>();
  double price = 0;
  final _total = 0.0.obs;
  var isShowHint = false.obs;

  TextEditingController textInputController = TextEditingController();

  String get total {
    return NumberUtils.vnd(_total.value * hourNum.value);
  }

  @override
  void onInit() {
    price = _rentingFormController.vehicleRental?.pricePerDay?.toDouble() ?? 0;
    _total.value = price;
    textInputController = TextEditingController(text: '1');
    setHourNum();
    super.onInit();
  }

  void setHourNum() {
    _rentingFormController.setHourNum(hourNum.value);
  }

  var hourNum = 1.obs;
  final _dateStartByHour = DateTime.now().obs;
  final _dateEndByHour = DateTime.now().add(const Duration(days: 1)).obs;

  String dateStartByHour() {
    _dateStartByHour.value = DateTime.now();
    return DateTimeUtils.dateTimeToString(_dateStartByHour.value);
  }

  String dateEndByHour() {
    _dateEndByHour.value = DateTime.now().add(Duration(hours: hourNum.value));
    return DateTimeUtils.dateTimeToString(_dateEndByHour.value);
  }

  void increaseHour() {
    if (hourNum.value == 6) {
      isShowHint.value = true;
      update();
      return;
    }
    hourNum.value++;
    textInputController.text = hourNum.value.toString();
    setHourNum();
    update();
  }

  void decreaseHour() {
    if (hourNum.value == 1) {
      isShowHint.value = true;
      update();
      return;
    }
    hourNum.value--;
    textInputController.text = hourNum.value.toString();
    setHourNum();
    update();
  }

  void onInputChange(String value) {
    int? num = int.tryParse(value);

    if (num == null || num < 1) {
      isShowHint.value = true;
      textInputController.text = '1';
      hourNum.value = 1;
      setHourNum();
      update();
      return;
    }

    if (num > 14) {
      isShowHint.value = true;
      textInputController.text = '14';
      hourNum.value = 14;
      setHourNum();
      update();
      return;
    }

    hourNum.value = num;
    setHourNum();
  }
}
