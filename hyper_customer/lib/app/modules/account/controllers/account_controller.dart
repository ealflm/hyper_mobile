import 'package:get/get.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class AccountController extends GetxController {
  var fingerprintState = false.obs;

  void toggleFingerprint() {
    fingerprintState.value = !fingerprintState.value;
  }

  void logout() {
    TokenManager.instance.clearToken();
    Get.offAllNamed(Routes.LOGIN);
  }
}
