import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SearchTextFieldController extends GetxController {
  SearchTextFieldController(this.editingController);

  final focusNode = FocusNode();
  var hasFocus = false;
  var isEmpty = true;
  bool get isShowClear => hasFocus && !isEmpty;
  TextEditingController editingController;

  @override
  void onInit() {
    focusNode.addListener(_onFocusChange);
    editingController.addListener(_onTextChange);
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    editingController.removeListener(_onTextChange);
    super.onClose();
  }

  void _onFocusChange() {
    hasFocus = focusNode.hasFocus;
    update();
  }

  void _onTextChange() {
    isEmpty = editingController.text.isEmpty;
    update();
  }

  void clearSearchField() {
    editingController.text = '';
  }
}
