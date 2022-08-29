import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_driver/app/core/controllers/signalr_controller.dart';
import 'package:hyper_driver/app/core/utils/map_polyline_utils.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/core/values/app_values.dart';
import 'package:hyper_driver/app/data/models/directions_model.dart';
import 'package:hyper_driver/app/data/repository/goong_repository.dart';
import 'package:hyper_driver/app/modules/pick-up/models/view_state.dart';
import 'package:latlong2/latlong.dart';

class PickUpController extends BaseController {
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  var state = PickUpState.came.obs;

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  Rx<LatLng?> startMarkerLocation = Rx<LatLng?>(null);
  Rx<LatLng?> endMarkerLocation = Rx<LatLng?>(null);

  void init() async {
    LatLng? currentLocation =
        await HyperMapController.instance.getCurrentLocation();
    startMarkerLocation.value = currentLocation;
    endMarkerLocation.value = startPlaceLocation;

    fetchGoongRoute(currentLocation, startPlaceLocation);
  }

  // End Region

  // Region Change State

  void changeState(PickUpState value) {
    state.value = value;
    if (value == PickUpState.picked) {
      startMarkerLocation.value = startPlaceLocation;
      endMarkerLocation.value = endPlaceLocation;

      fetchGoongRoute(startPlaceLocation, endPlaceLocation);
    }
  }

  // End Region

  LatLng? get startPlaceLocation {
    return SignalR.instance.startLocation.value;
  }

  LatLng? get endPlaceLocation {
    return SignalR.instance.endLocation.value;
  }

  // Region Fetch Route
  Directions? directions;

  Rx<List<LatLng>> routePoints = Rx<List<LatLng>>([]);
  var isFindingRoute = false.obs;
  LatLngBounds? currentBounds;
  var hasRoute = false.obs;

  Legs? legs;

  Future<void> fetchGoongRoute(
    LatLng? startPlaceLocation,
    LatLng? endPlaceLocation,
  ) async {
    isFindingRoute.value = true;

    List<LatLng> result = [];

    if (startPlaceLocation == null || endPlaceLocation == null) {
      Utils.showToast('Không có điểm đầu và điểm cuối');
    }

    var findRouteService =
        _goongRepository.findRoute(startPlaceLocation!, endPlaceLocation!);

    await callDataService(
      findRouteService,
      onSuccess: (Directions response) {
        directions = response;

        String overviewPolyline =
            directions?.routes?[0].overviewPolyline?.points ?? '';

        legs = directions?.routes?[0].legs?[0];

        result = MapPolylineUtils.decode(overviewPolyline);
        hasRoute.value = true;
      },
      onError: (DioError dioError) {
        isFindingRoute.value = false;
        Utils.showToast('Không tìm thấy đường đi phù hợp');
      },
    );

    isFindingRoute.value = false;
    routePoints.value = result;
    centerZoomFitBounds();
  }

  void centerZoomFitBounds() {
    currentBounds = LatLngBounds();
    for (LatLng point in routePoints.value) {
      currentBounds?.extend(point);
    }

    currentBounds?.pad(0.4);
    LatLng? ne = currentBounds?.northEast;
    LatLng? sw = currentBounds?.southWest;
    final heightBuffer = (sw!.latitude - ne!.latitude).abs() * 0.8;
    sw = LatLng(sw.latitude - heightBuffer, sw.longitude);
    currentBounds?.extend(sw);

    HyperMapController.instance.centerZoomFitBounds(currentBounds!);
  }

  void clearRoute() {
    routePoints.value.clear();
    hasRoute.value = false;
  }

  void focusOnStartPlace() {
    var startlocation = startPlaceLocation ?? LatLng(0, 0);

    HyperMapController.instance
        .moveToPosition(startlocation, zoom: AppValues.focusZoomLevel);
  }

  void focusOnEndPlace() {
    var endlocation = startPlaceLocation ?? LatLng(0, 0);

    HyperMapController.instance
        .moveToPosition(endlocation, zoom: AppValues.focusZoomLevel);
  }
  // End Region

}
