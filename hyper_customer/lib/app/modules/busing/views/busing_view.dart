import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/modules/busing/controllers/busing_controller.dart';
import 'package:hyper_customer/app/modules/busing/widgets/search_route.dart';

class BusingView extends GetView<BusingController> {
  const BusingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(
          children: const [
            SearchRoute(),
          ],
        ));
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
          "Tìm đường",
          style: h6.copyWith(color: AppColors.softBlack),
        ),
      ),
    );
  }
}
