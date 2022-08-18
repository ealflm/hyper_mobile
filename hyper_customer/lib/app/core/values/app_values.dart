import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppValues {
  static const String photoBaseUrl =
      'https://se32.blob.core.windows.net/admin/';

  static const String cardLinkQRPrefix = '[CLQR]';
  static const String rentingQRPrefix = '[RTQR]';
  static const String returnVehicleQRPrefix = '[RSQR]';
  static const String busQRPrefix = '[BSQR]';

  static double bottomAppBarHeight = 60.h;

  static double recallFee = 90000;

  static String myLocation = 'Vị trí của bạn';

  static const double overviewZoomLevel = 10.8;
  static const double focusZoomLevel = 13.7;
  static const double navigationModeZoomLevel = 17;
  static const double showBusStationMarkerZoomLevel = 12.8;

  static double busDirectionMinHeight = 140.h;
  static double busDirectionMaxHeight = 350.h;
}
