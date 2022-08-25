import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/booking/controllers/booking_controller.dart';
import 'package:hyper_customer/app/modules/booking/widgets/bottom.dart';
import 'package:hyper_customer/app/modules/booking/widgets/hyper_map.dart';
import 'package:hyper_customer/app/modules/booking/widgets/search_route.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SignalR.instance.stop();
        return true;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 180.h),
              child: const HyperMap(),
            ),
            const Bottom(),
            const SearchRoute(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 18.r,
        ),
        onPressed: () {
          SignalR.instance.stop();
          Get.back();
        },
      ),
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
      centerTitle: true,
      title: GestureDetector(
        onTap: () => Get.back(),
        child: Text(
          "Đặt xe",
          style: h6.copyWith(color: AppColors.softBlack),
        ),
      ),
    );
  }
}
