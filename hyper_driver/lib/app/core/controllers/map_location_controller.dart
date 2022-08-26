import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_driver/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';

class MapLocationController {
  LatLng? location;
  LocationPermission? permission;

  StreamSubscription<Position>? _positionStream;

  Future<void> init() async {
    await loadLocation();
  }

  Future<bool> checkPermission() async {
    permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> loadLocation() async {
    if (_positionStream != null) return true;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _deniedDialog();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _deniedForeverDialog();
    }

    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream().listen(
      (Position? position) async {
        location = LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
      },
    );

    return true;
  }

  Future<LatLng> getCurrentLocation() async {
    return location ?? LatLng(0, 0);
  }

  Future<void> _deniedDialog() async {
    await HyperDialog.show(
      barrierDismissible: false,
      title: 'Thông báo',
      content:
          'Vui lòng bật quyền truy cập vị trí của bạn để tiếp tục sử dụng dịch vụ',
      primaryButtonText: 'Bật định vị',
      secondaryButtonText: 'Trở về trang chủ',
      primaryOnPressed: () async {
        permission = await Geolocator.requestPermission();
        try {
          var result = await Geolocator.getCurrentPosition();
          Get.back();
          return result;
        } catch (e) {
          // return Future.error(e);
        }
      },
      secondaryOnPressed: () {
        Get.offAllNamed(Routes.MAIN);
      },
    );
  }

  Future<void> _deniedForeverDialog() async {
    await HyperDialog.show(
      barrierDismissible: false,
      title: 'Thông báo',
      content:
          'Bạn đã từ chối cho ứng dụng sử dụng vị trí của bạn. Vui lòng bật lại trong cài đặt.',
      primaryButtonText: 'Mở cài đặt',
      secondaryButtonText: 'Trở về trang chủ',
      primaryOnPressed: () async {
        await Geolocator.openAppSettings();
        try {
          var result = await Geolocator.getCurrentPosition();
          Get.back();
          return result;
        } catch (e) {
          // return Future.error(e);
        }
      },
      secondaryOnPressed: () {
        Get.offAllNamed(Routes.MAIN);
      },
    );
  }
}
