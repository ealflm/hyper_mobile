import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';
import 'package:hyper_driver/app/modules/renting_form/controllers/renting_form_controller.dart';

class RentingDayCountController extends BaseController {
  final RentingFormController _rentingFormController =
      Get.find<RentingFormController>();
  double price = 0;
  final _total = 0.0.obs;
  var isShowHint = false.obs;

  TextEditingController textInputController = TextEditingController();

  String get total {
    return NumberUtils.vnd(_total.value * dayNum.value);
  }

  @override
  void onInit() {
    price = _rentingFormController.vehicleRental?.pricePerDay?.toDouble() ?? 0;
    _total.value = price;
    textInputController = TextEditingController(text: '1');
    setDayNum();
    super.onInit();
  }

  void setDayNum() {
    _rentingFormController.setDayNum(dayNum.value);
  }

  var dayNum = 1.obs;
  final _dateStartByDay = DateTime.now().obs;
  final _dateEndByDay = DateTime.now().add(const Duration(days: 1)).obs;

  String dateStartByDay() {
    _dateStartByDay.value = DateTime.now();
    return DateTimeUtils.dateTimeToString(_dateStartByDay.value);
  }

  String dateEndByDay() {
    _dateEndByDay.value = DateTime.now().add(Duration(days: dayNum.value));
    return DateTimeUtils.dateTimeToString(_dateEndByDay.value);
  }

  void increaseDay() {
    if (dayNum.value == 14) {
      isShowHint.value = true;
      update();
      return;
    }
    dayNum.value++;
    textInputController.text = dayNum.value.toString();
    setDayNum();
    update();
  }

  void decreaseDay() {
    if (dayNum.value == 1) {
      isShowHint.value = true;
      update();
      return;
    }
    dayNum.value--;
    textInputController.text = dayNum.value.toString();
    setDayNum();
    update();
  }

  void onInputChange(String value) {
    int? num = int.tryParse(value);

    if (num == null || num < 1) {
      isShowHint.value = true;
      textInputController.text = '1';
      dayNum.value = 1;
      setDayNum();
      update();
      return;
    }

    if (num > 14) {
      isShowHint.value = true;
      textInputController.text = '14';
      dayNum.value = 14;
      setDayNum();
      update();
      return;
    }

    dayNum.value = num;
    setDayNum();
  }
}
