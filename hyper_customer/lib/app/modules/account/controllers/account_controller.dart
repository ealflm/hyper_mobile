import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/notification_controller.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';

class AccountController extends GetxController {
  var fingerprintState = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    _loadUser();
    _getFingerprintMode();
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

  void logout() {
    TokenManager.instance.clearToken();
    NotificationController.instance.unregisterNotification();
    SignalR.instance.stop();
    Get.offAllNamed(Routes.LOGIN);
  }
}
