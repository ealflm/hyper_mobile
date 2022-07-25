import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/renting/widgets/bottom.dart';
import 'package:hyper_customer/app/modules/renting/widgets/map.dart';
import 'package:hyper_customer/app/modules/renting/widgets/top.dart';

import '../controllers/renting_controller.dart';

class RentingView extends GetView<RentingController> {
  const RentingView({Key? key}) : super(key: key);

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
