import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppValues {
  static const String CardLinkQRPrefix = '[CLQR]';
  static const String RentingQRPrefix = '[RTQR]';

  static double bottomAppBarHeight = 60.h;

  static double recallFee = 90000;

  static String myLocation = 'Vị trí của bạn';

  static const double overviewZoomLevel = 10.8;
  static const double focusZoomLevel = 13.7;
  static const double navigationModeZoomLevel = 17;

  static double busDirectionMinHeight = 140.h;
  static double busDirectionMaxHeight = 350.h;
}
