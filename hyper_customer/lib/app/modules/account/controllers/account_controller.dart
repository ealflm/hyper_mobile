import 'package:get/get.dart';
import 'package:hyper_customer/app/data/models/user_model.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class AccountController extends GetxController {
  var fingerprintState = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    _loadUser();
    super.onInit();
  }

  void _loadUser() {
    if (TokenManager.instance.hasUser) {
      user(TokenManager.instance.user!);
    }
  }

  void toggleFingerprint() {
    fingerprintState.value = !fingerprintState.value;
  }

  void logout() {
    TokenManager.instance.clearToken();
    Get.offAllNamed(Routes.LOGIN);
  }
}
