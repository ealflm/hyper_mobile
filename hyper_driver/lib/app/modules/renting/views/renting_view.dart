import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/modules/renting/widgets/bottom.dart';
import 'package:hyper_driver/app/modules/renting/widgets/hyper_map.dart';
import 'package:hyper_driver/app/modules/renting/widgets/top.dart';

import '../controllers/renting_controller.dart';

class RentingView extends GetView<RentingController> {
  const RentingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.backButtonPressed();
        return true;
      },
      child: StatusBar(
        brightness: Brightness.dark,
        child: Scaffold(
          body: Stack(children: const [
            HyperMap(),
            Top(),
            Bottom(),
          ]),
        ),
      ),
    );
  }
}
