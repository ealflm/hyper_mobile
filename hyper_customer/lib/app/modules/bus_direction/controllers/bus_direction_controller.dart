import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/animated_map_controller.dart';
import 'package:hyper_customer/app/core/controllers/map_location_controller.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/modules/renting/controllers/renting_map_controller.dart';

class BusDirectionController extends GetxController {
  MapController mapController = MapController();
  late MapLocationController _mapLocationController;
  late MapMoveController _mapMoveController;

  BusDirection? busDirection;

  var isExpanded = true.obs;

  @override
  void onInit() {
    busDirection = Get.arguments['busDirection'];
    init();
    super.onInit();
  }

  void init() async {
    AnimatedMapController.init(controller: mapController);
    _mapMoveController = MapMoveController(mapController);
    _mapLocationController = MapLocationController();
    await _mapLocationController.init();
  }

  void goToCurrentLocation({double? zoom}) async {
    await _mapLocationController.loadLocation();
    var currentLocation = _mapLocationController.location;

    await _mapLocationController.loadLocation();

    _mapMoveController.moveToPosition(
      currentLocation!,
      zoom: zoom ?? AppValues.focusZoomLevel,
    );
  }

  void toggleExpand() {
    isExpanded.value = !isExpanded.value;
  }
}
