import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:intl/intl.dart';

abstract class Utils {
  static void showToast(String message) {
    Fluttertoast.showToast(
      backgroundColor: AppColors.black.withOpacity(0.5),
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  // static NumberFormat numberFormat = NumberFormat.decimalPattern('en_US');
  static NumberFormat numberFormat = NumberFormat();

  static String vnd(double? value) {
    if (value == null || value < 0.0) return '-';
    return "${Utils.numberFormat.format(value)} VNĐ";
  }
}
