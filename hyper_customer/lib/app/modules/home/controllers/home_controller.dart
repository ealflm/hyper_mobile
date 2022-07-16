import 'package:flutter/material.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/modules/home/model/header_state.dart';

class HomeController extends BaseController {
  final contentKey = GlobalKey<AnimatedListState>();
  final HeaderState headerState = HeaderState();

  void toggleHeader() {
    headerState.toggle();
  }
}
