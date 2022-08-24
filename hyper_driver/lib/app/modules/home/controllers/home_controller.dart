import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/data/repository/goong_repository.dart';

class HomeController extends BaseController {
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  void init() async {}

  // End Region

}
