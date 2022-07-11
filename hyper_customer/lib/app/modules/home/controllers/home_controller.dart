import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/modules/home/model/header_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class HomeController extends BaseController {
  final contentKey = GlobalKey<AnimatedListState>();
  final HeaderState headerState = HeaderState();

  void toggleHeader() {
    headerState.toggle();
  }

  void logout() {
    TokenManager.instance.clearToken();
    Get.offAllNamed(Routes.LOGIN);
  }
}
