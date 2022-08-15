import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/controllers/setting_controller.dart';
import 'package:hyper_driver/app/core/utils/number_utils.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/data/models/user_model.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';

class PaymentController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  final depositController = TextEditingController();

  final depositFocusNode = FocusNode();
  var depositHasFocus = false;
  var isEmpty = true;
  bool get isShowClear => depositHasFocus && !isEmpty;

  var selectedPaymentMethod = 1;
  String? depositText;

  double accountBalance = -1.0;
  bool get hasAccountBalance {
    return accountBalance >= 0;
  }

  var accountBalanceIsLoading = false.obs;
  var submitIsLoading = false.obs;

  String get accountBlanceVND => NumberUtils.vnd(accountBalance);

  void _loadSetting() {
    accountBalance = SettingController.intance.accountBalance;
  }

  void _saveSetting() {
    SettingController.intance.accountBalance = accountBalance;
  }

  Future<void> reload() async {
    await _getAccountBalance();
  }

  Future<void> _getAccountBalance() async {
    accountBalanceIsLoading.value = true;
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

    accountBalanceIsLoading.value = false;
    update();
  }

  @override
  void onInit() {
    depositFocusNode.addListener(_onFocusChange);
    depositController.addListener(_onTextChange);
    _loadSetting();
    _getAccountBalance();
    super.onInit();
  }

  @override
  void onClose() {
    depositFocusNode.removeListener(_onFocusChange);
    depositFocusNode.dispose();
    depositController.removeListener(_onTextChange);
    depositController.dispose();
    super.onClose();
  }

  void _onFocusChange() {
    depositHasFocus = depositFocusNode.hasFocus;
    update();
  }

  void _onTextChange() {
    isEmpty = depositController.text.isEmpty;
    update();
  }

  void changeDeposit(String value) {
    depositController.text = value;
    depositController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: depositController.text.length,
      ),
    );
    formKey.currentState!.validate();
  }

  void changePaymentMethod(int value) {
    selectedPaymentMethod = value;
    update();
  }

  double getDouble(String value) {
    return double.tryParse(value.replaceAll('.', '')) ?? 0;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    submitIsLoading.value = true;

    double depositValue = getDouble(depositText!);

    User? user = TokenManager.instance.user;
    if (user == null) {
      Get.offAllNamed(Routes.START);
    }
    String customerId = user?.customerId ?? '';

    var depositService = _repository.deposit(
      depositValue,
      selectedPaymentMethod,
      customerId,
    );

    String result = '';

    await callDataService(
      depositService,
      onSuccess: (String response) {
        result = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    submitIsLoading.value = false;

    if (result.isNotEmpty) {
      if (selectedPaymentMethod == 0) {
        Get.toNamed(
          Routes.PAYPAL,
          arguments: {'id': result},
        );
      } else if (selectedPaymentMethod == 1) {
        Get.toNamed(
          Routes.MOMO,
          arguments: {'initialUrl': result},
        );
      }
    }
  }
}
