import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoPlayerController;

  @override
  void onInit() async {
    super.onInit();
    _initializedPlayer();
  }

  Future<void> _initializedPlayer() async {
    videoPlayerController = VideoPlayerController.asset(AppAssets.splash);
    videoPlayerController.initialize().then((_) => (update()));
    videoPlayerController.setVolume(0);
    videoPlayerController.play();
  }

  @override
  void onReady() async {
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    Get.offAllNamed(Routes.START);
    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
