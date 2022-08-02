import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/bus_station_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/bus_stations_model.dart';
import 'package:hyper_customer/app/data/models/place_detail_model.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:latlong2/latlong.dart';

class SelectOnMapController extends BaseController {
  final GoongRepository _goongRepository =
      Get.find(tag: (GoongRepository).toString());

  HyperMapController mapController = HyperMapController();

  late BusStationController busStationController;

  var isShowCenterMarker = false.obs;
  var isWaiting = true.obs;

  // Region Init

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  void init() async {
    busStationController = BusStationController(mapController);

    _delayCenterMarker();
    _goToCurrentLocationWithZoomDelay();
  }

  void _delayCenterMarker() async {
    await Future.delayed(const Duration(milliseconds: 950));
    isShowCenterMarker.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    fetchPlaceDetail();
    isWaiting.value = false;
  }

  void _onPressedBusStationMarker() {
    BusStation? busStation = busStationController.selectedBusStation();
    if (busStation == null) return;
    PlaceDetail place = PlaceDetail(
      placeId: busStation.id,
      name: busStation.title,
      formattedAddress: '${busStation.title}, ${busStation.address}',
      geometry: Geometry(
        location: Location(
          lat: busStation.location?.latitude,
          lng: busStation.location?.longitude,
        ),
      ),
    );
    placeDetail(place);
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
    fetchPlaceDetail();
  }

  void _goToCurrentLocation({double? zoom}) async {
    mapController.moveToCurrentLocation(zoom: zoom ?? AppValues.focusZoomLevel);
  }

  void _moveToSelectedPlace() {
    if (placeDetail.value.placeId == null) return;

    double lat = placeDetail.value.geometry?.location?.lat ?? 0;
    double lng = placeDetail.value.geometry?.location?.lng ?? 0;

    var location = LatLng(lat, lng);
    mapController.moveToPosition(location);
  }

  // End Region

  // Region Place Detail

  Rx<PlaceDetail> placeDetail = Rx<PlaceDetail>(PlaceDetail());
  var isLoadingPlaceDetail = true.obs;

  Future<void> fetchPlaceDetail() async {
    isLoadingPlaceDetail.value = true;

    LatLng? currentLocation = mapController.controller.center;

    var placeIdService = _goongRepository.getPlaceId(currentLocation);
    String? placeId;

    await callDataService(
      placeIdService,
      onSuccess: (String response) {
        placeId = response;
      },
      onError: (dioError) {},
    );

    if (placeId == null) {
      isLoadingPlaceDetail.value = false;
      return;
    }

    var placeDetailService = _goongRepository.getPlaceDetail(placeId!);

    await callDataService(
      placeDetailService,
      onSuccess: (PlaceDetail response) {
        placeDetail(response);
      },
      onError: (dioError) {},
    );

    _moveToSelectedPlace();

    isLoadingPlaceDetail.value = false;
  }

  // End Region

  // Region Listener

  void onPointerDown() {
    isWaiting.value = true;
  }

  void onPointerUp() async {
    if (isLoadingPlaceDetail.value) return;
    await fetchPlaceDetail();
    isWaiting.value = false;
  }

  // End Region

  // Region

  void submit() {
    if (placeDetail.value.placeId == null) return;
    Get.back(result: placeDetail.value);
  }

  // End Region

}
