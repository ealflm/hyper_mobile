import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/controllers/hyper_map_controller.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/data/models/bus_stations_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';

import '../values/app_assets.dart';

class BusStationController extends BaseController {
  HyperMapController mapController = HyperMapController();
  final Repository _repository = Get.find(tag: (Repository).toString());

  Rx<BusStations?> busStations = Rx<BusStations?>(null);
  Rx<List<Marker>> busStationMarkers = Rx<List<Marker>>([]);
  String? _selectedBusStationId;
  final Map<String, BusStation> _busStationsMap = {};

  Function()? onPressed;

  BusStationController(this.mapController, {this.onPressed}) {
    fetchBusStation();
  }

  void fetchBusStation() async {
    var busStationService = _repository.getBusStation();

    await callDataService(
      busStationService,
      onSuccess: (BusStations response) {
        busStations(response);
      },
      onError: (DioError dioError) {},
    );
    _updateBusStation();
  }

  void selectBusStation(String? id) {
    _selectedBusStationId = id;
    _updateBusStation();
  }

  void clearBusStation() {
    _selectedBusStationId = '';
    _updateBusStation();
  }

  BusStation? selectedBusStation() {
    if (_selectedBusStationId == null) return null;
    return _busStationsMap[_selectedBusStationId];
  }

  void _updateBusStation() {
    if (busStations.value == null) {
      return;
    }
    List<Marker> markers = [];

    for (BusStation item in (busStations.value?.busStationList ?? [])) {
      if (item.location == null) return;
      _busStationsMap[item.id!] = item;
      markers.add(
        _selectedBusStationId != item.id
            ? Marker(
                width: 80.r,
                height: 80.r,
                point: item.location!,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(20.r),
                    child: GestureDetector(
                      onTap: () {
                        selectBusStation(item.id);
                        if (onPressed != null) {
                          onPressed!();
                        }
                      },
                      child: Container(
                        color: AppColors.white.withOpacity(0),
                        padding: EdgeInsets.all(10.r),
                        child: SvgPicture.asset(
                          AppAssets.busIcon,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Marker(
                width: 200.r,
                height: 90.r,
                point: item.location!,
                builder: (context) {
                  return IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecorations.mapLabel(),
                          child: Text(
                            '${item.title}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: body2.copyWith(
                              color: AppColors.softBlack,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SvgPicture.asset(
                          AppAssets.busIcon,
                          height: 25.r,
                          width: 25.r,
                        ),
                      ],
                    ),
                  );
                },
              ),
      );
    }
    busStationMarkers(markers);
  }
}
