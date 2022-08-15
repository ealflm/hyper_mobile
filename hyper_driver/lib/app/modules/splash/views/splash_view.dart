import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:video_player/video_player.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Center(
          child: GetBuilder<SplashController>(
            builder: (controller) => SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.videoPlayerController.value.size.width,
                  height: controller.videoPlayerController.value.size.height,
                  child: VideoPlayer(controller.videoPlayerController),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
