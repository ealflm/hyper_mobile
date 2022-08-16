import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/modules/pick-up/widgets/bottom.dart';
import 'package:hyper_driver/app/modules/pick-up/widgets/hyper_map.dart';
import 'package:hyper_driver/app/modules/pick-up/widgets/top.dart';

import '../controllers/pick_up_controller.dart';

class PickUpView extends GetView<PickUpController> {
  const PickUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(children: const [
          HyperMap(),
          Top(),
          Bottom(),
        ]),
      ),
    );
  }
}
