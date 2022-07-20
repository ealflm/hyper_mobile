import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  static String? vnd(double? value) {
    if (value == null || value < 0.0) return null;
    return "${Utils.numberFormat.format(value)} VNĐ";
  }

  static DateTime? parseDateTime(int? timestamp) {
    return timestamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static String? dateTimeToString(DateTime? dateTime) {
    initializeDateFormatting();
    return dateTime == null
        ? null
        : DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }
}
