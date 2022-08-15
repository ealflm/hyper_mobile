import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/modules/home/widgets/bottom.dart';
import 'package:hyper_driver/app/modules/home/widgets/hyper_map.dart';
import 'package:hyper_driver/app/modules/home/widgets/top.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
