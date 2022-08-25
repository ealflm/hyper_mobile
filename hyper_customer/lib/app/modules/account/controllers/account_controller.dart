import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/notification_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/scan/models/scan_mode.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';

class AccountController extends BaseController {
  var fingerprintState = false.obs;
  Rx<User?> user = Rx<User?>(null);
  final Repository _repository = Get.find(tag: (Repository).toString());

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    _loadUser();
    _getFingerprintMode();
    getCardStatus();
  }

  Rx<bool> cardStatus = false.obs;

  void getCardStatus() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var cardService = _repository.getCardStatus(customerId);

    await callDataService(
      cardService,
      onSuccess: (bool response) {
        cardStatus.value = true;
      },
      onError: (DioError dioError) {
        cardStatus.value = false;
      },
    );
  }

  Future<bool> removeCard() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var cardService = _repository.removeCard(customerId);

    bool result = false;

    await callDataService(
      cardService,
      onSuccess: (bool response) {
        result = true;
      },
      onError: (DioError dioError) {
        result = false;
      },
    );

    return result;
  }

  Future<bool> updateCard(String code) async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    var cardService = _repository.updateCard(customerId, code);

    bool result = false;

    await callDataService(
      cardService,
      onSuccess: (bool response) {
        result = true;
      },
      onError: (DioError dioError) {
        result = false;
      },
    );

    return result;
  }

  void toggleCardStatus() async {
    if (cardStatus.value == false) {
      String code = await Get.toNamed(
        Routes.SCAN,
        arguments: {
          'scanMode': ScanMode.cardFromAccount,
        },
      );

      HyperDialog.showLoading();

      bool result = await updateCard(code);

      if (result == true) {
        cardStatus.value = true;
        HyperDialog.show(
          title: 'Thành công',
          content: 'Liên kết thẻ thành công',
          primaryButtonText: 'Ok',
          primaryOnPressed: Get.back,
        );
      } else {
        HyperDialog.show(
          title: 'Thất bại',
          content: 'Liên kết thất bại',
          primaryButtonText: 'Ok',
          primaryOnPressed: Get.back,
        );
      }
    } else {
      bool result = await removeCard();
      if (result == true) {
        cardStatus.value = false;
      } else {
        HyperDialog.show(
          title: 'Thất bại',
          content: 'Huỷ liên kết thất bại',
          primaryButtonText: 'Ok',
          primaryOnPressed: Get.back,
        );
      }
    }
  }

  void _getFingerprintMode() async {
    fingerprintState.value = await TokenManager.instance.getMode();
  }

  void fingerprintOnChanged(bool value) {
    if (value == true) {
      TokenManager.instance.setMode(false);
      fingerprintState.value = false;
      Utils.showToast('Đã tắt tính năng đăng nhập bằng vân tay');
    } else {
      registerFingerprint();
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  void registerFingerprint() async {
    bool didAuthenticate = false;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason:
            'Vui lòng quét vân tay để kích hoạt tính năng đăng nhập bằng vân tay',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Đăng nhập với vân tay',
            cancelButton: 'Huỷ',
            biometricHint: 'Yêu cầu vân tay',
          ),
        ],
      );
    } on PlatformException {
      //
    }

    if (didAuthenticate) {
      TokenManager.instance.setMode(true);
      fingerprintState.value = true;
      HyperDialog.show(
        title: 'Kích hoạt thành công',
        content: 'Kích hoạt đăng nhập bằng vân tay thành công',
        primaryButtonText: 'OK',
      );
    } else {
      Utils.showToast('Kích hoạt đăng nhập bằng vân tay thất bại');
    }
  }

  void _loadUser() {
    if (TokenManager.instance.hasUser) {
      user(TokenManager.instance.user!);
    }
  }

  void toggleFingerprint() {
    fingerprintOnChanged(fingerprintState.value);
  }

  void logout() async {
    TokenManager.instance.clearToken();
    NotificationController.instance.unregisterNotification();
    Get.offAllNamed(Routes.LOGIN);
  }
}
