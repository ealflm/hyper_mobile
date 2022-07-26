import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';

class MapLocationController {
  LatLng? location;
  LocationPermission? permission;

  Future<void> init() async {
    await loadLocation();
  }

  Future<bool> checkPermission() async {
    permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> loadLocation() async {
    try {
      location = await _getCurrentLocation();
      return true;
    } catch (e) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _deniedDialog();
        }
      }

      await _deniedForeverDialog();

      return Future.error('Unknown error');
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng result = LatLng(position.latitude, position.longitude);
      return result;
    } catch (e) {
      return Future.error(e);
    }
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
