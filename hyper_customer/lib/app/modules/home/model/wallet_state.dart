import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletState {
  var fullHeight = 104.h;
  var lessHeight = 0.h;

  final _height = 104.h.obs;
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
