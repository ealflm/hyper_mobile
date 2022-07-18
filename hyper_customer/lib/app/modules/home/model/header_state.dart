import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HeaderState {
  var fullHeight = 212.h;
  var lessHeight = 83.h;

  final _height = 212.h.obs;
  final _walletUiState = false.obs;

  get height => _height.value;
  get walletUiState => _walletUiState.value;

  void setWalletUiState(bool value) {
    _walletUiState.value = value;
    if (!_walletUiState.value) {
      _height.value = fullHeight;
    } else {
      _height.value = lessHeight;
    }
  }

  void toggle() {
    _walletUiState.value = !_walletUiState.value;
    if (!_walletUiState.value) {
      _height.value = fullHeight;
    } else {
      _height.value = lessHeight;
    }
  }
}
