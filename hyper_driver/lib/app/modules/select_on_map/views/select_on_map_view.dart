import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';
import 'package:hyper_driver/app/modules/select_on_map/widgets/bottom.dart';
import 'package:hyper_driver/app/modules/select_on_map/widgets/hyper_map.dart';
import 'package:hyper_driver/app/modules/select_on_map/widgets/top.dart';

import '../controllers/select_on_map_controller.dart';

class SelectOnMapView extends GetView<SelectOnMapController> {
  const SelectOnMapView({Key? key}) : super(key: key);
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
