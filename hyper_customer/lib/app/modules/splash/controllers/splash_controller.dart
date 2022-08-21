import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/login_init.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoPlayerController;

  @override
  Future<void> onInit() async {
    _initializedPlayer();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));

    if (TokenManager.instance.hasToken) {
      loginInit();
      Get.offAllNamed(Routes.MAIN);
    } else if (TokenManager.instance.hasUser) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.START);
    }

    super.onReady();
  }

  Future<void> _initializedPlayer() async {
    videoPlayerController = VideoPlayerController.asset(AppAssets.splash)
      ..setVolume(0.0);
    videoPlayerController.initialize().then((_) => (update()));
    videoPlayerController.play();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
