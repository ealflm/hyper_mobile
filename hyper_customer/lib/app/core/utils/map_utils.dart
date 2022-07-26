import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

abstract class MapUtils {
  static Future<Position> determinePosition() async {
    LocationPermission permission;

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e);
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
        await HyperDialog.show(
          barrierDismissible: false,
          title: 'Thông báo',
          content:
              'Vui lòng bật quyền truy cập vị trí của bạn để tiếp tục sử dụng dịch vụ',
          primaryButtonText: 'Bật định vị',
          secondaryButtonText: 'Trở về trang chủ',
          primaryOnPressed: () async {
            await Geolocator.requestPermission();
            try {
              var result = await Geolocator.getCurrentPosition();
              Get.back();
              return result;
            } catch (e) {
              print(e);
            }
          },
          secondaryOnPressed: () {
            Get.back();
            Get.offAllNamed(Routes.MAIN);
          },
        );
      }
    }

    await _deniedForeverDialog();

    return Future.error('Unknown error');
  }

  static Future<void> _deniedForeverDialog() async {
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
          print(e);
        }
      },
      secondaryOnPressed: () {
        Get.back();
        Get.offAllNamed(Routes.MAIN);
      },
    );
  }
}
