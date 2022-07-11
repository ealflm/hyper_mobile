import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HeaderState {
  var fullHeight = 212.h;
  var lessHeight = 83.h;

  final _height = 212.h.obs;
  final _isToggle = false.obs;

  get height => _height.value;
  get isToggle => _isToggle.value;

  void toggle() {
    _isToggle.value = !_isToggle.value;
    if (!_isToggle.value) {
      _height.value = fullHeight;
    } else {
      _height.value = lessHeight;
    }
  }
}
