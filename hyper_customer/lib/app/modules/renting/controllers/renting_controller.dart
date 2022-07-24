import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting/widgets/search_item.dart';
import 'package:hyper_customer/config/build_config.dart';
import 'package:tiengviet/tiengviet.dart';

// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class RentingController extends BaseController {
  String urlTemplate = BuildConfig.instance.config.mapUrlTemplate;
  String accessToken = BuildConfig.instance.config.mapAccessToken;
  String mapId = BuildConfig.instance.config.mapId;

  final Repository _repository = Get.find(tag: (Repository).toString());
  RentStations? rentStations;

  MapController? mapController;

  List<Widget> searchItems = [];
  List<Marker> markers = [];

  @override
  void onInit() async {
    await determinePosition();
    await getRentStations();
    super.onInit();
  }

  void onMapCreated(MapController controller) {
    mapController = controller;
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
      markers.add(
        Marker(
          width: 40.r,
          height: 40.r,
          point: LatLng(item.latitude ?? 0, item.longitude ?? 0),
          builder: (context) => GestureDetector(
            onTap: () {
              debugPrint('Location: ${item.latitude}, ${item.longitude}');
            },
            child: const Icon(
              Icons.location_on,
              color: AppColors.blue,
            ),
          ),
        ),
      );
    }
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
}
