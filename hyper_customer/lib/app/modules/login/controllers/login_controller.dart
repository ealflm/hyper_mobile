import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/notification_controller.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/data/models/auth_model.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';

class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final Repository _repository = Get.find(tag: (Repository).toString());

  String? token;
  String? password;
  var phoneNumber = ''.obs;
  String fullName = '';

  String? registerPassword;

  var hasFingerprint = false.obs;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('phoneNumber')) {
        phoneNumber.value = data['phoneNumber'];
      }
      if (data.containsKey('registerPassword')) {
        registerPassword = data['registerPassword'];
      }
    }
    if (TokenManager.instance.hasUser) {
      User user = TokenManager.instance.user!;
      fullName = '${user.firstName} ${user.lastName}';
      if (phoneNumber.value.isEmpty) {
        phoneNumber.value = user.phone ?? '';
      }
    }
    await checkFingerprint();
    super.onInit();
  }

  @override
  void onReady() {
    if (phoneNumber.value.isEmpty) Get.offAllNamed(Routes.START);
    if (registerPassword != null && hasFingerprint.value) {
      TokenManager.instance
          .savePhonePassword(phoneNumber.value, registerPassword);
      HyperDialog.show(
        title: 'Đăng nhập bằng vân tay',
        content:
            'Bạn có muốn kích hoạt tính năng đăng nhập bằng vân tay không?',
        primaryButtonText: 'Đồng ý',
        primaryOnPressed: () {
          Get.back();
          registerFingerprint();
        },
        secondaryButtonText: 'Huỷ',
        secondaryOnPressed: () => Get.back(),
      );
    }
    super.onReady();
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> checkFingerprint() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.weak) ||
        availableBiometrics.contains(BiometricType.fingerprint)) {
      hasFingerprint.value = true;
    }
  }

  void loginWithFingerprint() async {
    bool mode = await TokenManager.instance.getMode();
    String? phone = await TokenManager.instance.getPhone();
    String? password = await TokenManager.instance.getPassword();

    if (mode == false || phone == null || password == null) {
      HyperDialog.show(
        title: 'Chưa kích hoạt',
        content:
            'Bạn chưa kích hoạt tính năng đăng nhập bằng vân tay. Vui lòng đăng nhập bằng mã PIN và kích hoạt ở mục tài khoản',
        primaryButtonText: 'OK',
      );
      return;
    }

    bool didAuthenticate = false;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Vui lòng quét vân tay để đăng nhập',
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
      login(phone, password);
    } else {
      Utils.showToast('Đăng nhập thất bại');
    }
  }

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
      TokenManager.instance.savePhonePassword(
        phoneNumber.value,
        registerPassword,
        mode: true,
      );
      HyperDialog.show(
        title: 'Kích hoạt thành công',
        content: 'Kích hoạt đăng nhập bằng vân tay thành công',
        primaryButtonText: 'OK',
      );
    }
  }

  var pageLoading = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    pageLoading.value = true;

    var loginService = _repository.login(phoneNumber.value, password!);

    await callDataService(
      loginService,
      onSuccess: (Auth? response) {
        token = response?.token;
      },
      onError: (DioError dioError) {
        var response = dioError.response;

        if (response != null &&
            response.data.toString().isNotEmpty &&
            response.data['detail'] == 'Invalid user name or password') {
          HyperDialog.show(
            title: 'Sai mã PIN',
            content: 'Mã PIN bạn vừa nhập chưa chính xác. Vui lòng thử lại',
            primaryButtonText: 'OK',
          );
        } else {
          Utils.showToast('Kết nối thất bại');
        }
      },
    );

    await Future.delayed(const Duration(seconds: 1));

    pageLoading.value = false;

    if (token != null) {
      await TokenManager.instance.saveToken(token);
      await TokenManager.instance.saveUser(token);
      await TokenManager.instance.savePhonePassword(
        phoneNumber.value,
        password!,
      );
      Get.offAllNamed(Routes.MAIN);
      SignalRController.instance.init();
      NotificationController.instance.registerNotification();
    }
  }

  Future<void> login(String phone, String password) async {
    var loginService = _repository.login(phone, password);

    pageLoading.value = true;

    await callDataService(
      loginService,
      onSuccess: (Auth? response) {
        token = response?.token;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    await Future.delayed(const Duration(seconds: 1));

    pageLoading.value = false;

    if (token != null) {
      await TokenManager.instance.saveToken(token);
      await TokenManager.instance.saveUser(token);
      await TokenManager.instance.savePhonePassword(
        phone,
        password,
      );
      NotificationController.instance.registerNotification();

      SignalRController.instance.init();
      Get.offAllNamed(Routes.MAIN);
    }
  }

  void back() {
    TokenManager.instance.clearUser();
    TokenManager.instance.clearPhonePassword();
    Get.offAllNamed(Routes.START);
  }
}
