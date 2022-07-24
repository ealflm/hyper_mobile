import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/widgets/search_item.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:tiengviet/tiengviet.dart';

// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class RentingController extends BaseController
    with GetTickerProviderStateMixin {
  String urlTemplate = BuildConfig.instance.config.mapUrlTemplate;
  String accessToken = BuildConfig.instance.config.mapAccessToken;
  String mapId = BuildConfig.instance.config.mapId;

  final Repository _repository = Get.find(tag: (Repository).toString());
  RentStations? rentStations;

  MapController mapController = MapController();

  List<Widget> searchItems = [];
  List<Marker> markers = [];

  double defaultZoomLevel = 10.8;
  double zoomLevel = 10.8;

  @override
  void onInit() async {
    await determinePosition();
    await getRentStations();
    super.onInit();
  }

  void onPositionChanged(MapPosition position, bool hasGesture) {
    zoomLevel = position.zoom ?? defaultZoomLevel;
  }

  void _moveToPosition(LatLng position) {
    var zoomLevel = mapController.zoom;
    _animatedMapMove(position, zoomLevel);
  }

  Future<void> getRentStations() async {
    var rentStationsService = _repository.getRentStations();

    await callDataService(
      rentStationsService,
      onSuccess: (RentStations? response) {
        rentStations = response;
      },
      onError: (DioError dioError) {
        Utils.showToast('Kết nối thất bại');
      },
    );

    markers.clear();
    var items = rentStations?.body?.items ?? [];
    for (Items item in items) {
      double lat = item.latitude ?? 0;
      double lng = item.longitude ?? 0;
      var location = LatLng(lat, lng);
      markers.add(
        Marker(
          width: 18.r,
          height: 18.r,
          point: location,
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _moveToPosition(location);
            },
            child: SizedBox(
              width: 18.r,
              height: 18.r,
              child: SvgPicture.asset(
                AppAssets.rentingMapIcon,
              ),
            ),
          ),
        ),
      );
    }

    update();
  }

  bool _contains(String? text, String? keyword) {
    if (text == null || keyword == null) {
      return false;
    }
    var unSignText = TiengViet.parse(text.toLowerCase().trim());
    var unSignKeyword = TiengViet.parse(keyword.toLowerCase().trim());
    return unSignText.contains(unSignKeyword);
  }

  void clearSearchItems() {
    searchItems.clear();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchItems.clear();
      update();
      return;
    }
    if (rentStations != null) {
      searchItems.clear();
      var items = rentStations?.body?.items ?? [];
      for (Items item in items) {
        if (_contains(item.title, query) || _contains(item.address, query)) {
          var searchItem = SearchItem(
            title: item.title ?? '',
            description: item.address ?? '',
            onPressed: () {},
          );
          searchItems.add(searchItem);
        }
      }
    }

    update();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
