import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/setting_controller.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/home/model/header_state.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

class HomeController extends BaseController {
  final contentKey = GlobalKey<AnimatedListState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  final HeaderState headerState = HeaderState();
  double accountBalance = -1.0;

  Rx<User?> user = Rx<User?>(null);

  String get accountBlanceVND => NumberUtils.vnd(accountBalance);

  @override
  Future<void> onInit() async {
    init();
    super.onInit();
  }

  void init() {
    _getAccountBalance();
    _loadUser();
    _loadSetting();
  }

  void _loadUser() {
    if (TokenManager.instance.hasUser) {
      user(TokenManager.instance.user!);
    }
  }

  void _loadSetting() {
    headerState.setWalletUiState(SettingController.intance.walletUiState);
    accountBalance = SettingController.intance.accountBalance;
  }

  void _saveSetting() {
    SettingController.intance.accountBalance = accountBalance;
    SettingController.intance.saveAccountBalance(accountBalance);
  }

  Future<void> reload() async {
    await _getAccountBalance();
  }

  void toggleHeader() {
    headerState.toggle();
    SettingController.intance.saveWalletUiStatus(headerState.walletUiState);
  }

  Future<void> _getAccountBalance() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;
    var accountBalanceService = _repository.getBalance(customerId);

    await callDataService(
      accountBalanceService,
      onSuccess: (double response) {
        accountBalance = response;
      },
      onError: (dioError) {
        debugPrint(dioError.message);
      },
    );

    _saveSetting();
    update();
  }
}
