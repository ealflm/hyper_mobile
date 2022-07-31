import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/bottom.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/hyper_map.dart';
import 'package:hyper_customer/app/modules/bus_direction/widgets/top.dart';

import '../controllers/bus_direction_controller.dart';

class BusDirectionView extends GetView<BusDirectionController> {
  const BusDirectionView({Key? key}) : super(key: key);
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
