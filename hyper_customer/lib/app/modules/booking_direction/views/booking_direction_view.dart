import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/network/signalr.dart';
import 'package:hyper_customer/app/core/widgets/status_bar.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/bottom.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/hyper_map.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/top.dart';

import '../controllers/booking_direction_controller.dart';

class BookingDirectionView extends GetView<BookingDirectionController> {
  const BookingDirectionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await SignalR.instance.canceledFinding();
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
