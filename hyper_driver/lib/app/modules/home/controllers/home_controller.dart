import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/data/repository/goong_repository.dart';

class HomeController extends BaseController {
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  HyperMapController mapController = HyperMapController();

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  void init() async {
    _delayCenterMarker();
    _goToCurrentLocationWithZoomDelay();
  }

  void _delayCenterMarker() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  // End Region

  // Region Go to

  void _goToCurrentLocationWithZoomDelay({double? zoom}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    mapController.moveToCurrentLocation(zoom: zoom ?? AppValues.focusZoomLevel);
  }

  void goToCurrentLocation() async {
    _goToCurrentLocation();
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  void _goToCurrentLocation({double? zoom}) async {
    mapController.moveToCurrentLocation(zoom: zoom ?? AppValues.focusZoomLevel);
  }

  // End Region
}
