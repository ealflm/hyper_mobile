import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';

abstract class Utils {
  static void showToast(String message) {
    Fluttertoast.showToast(
      backgroundColor: AppColors.black.withOpacity(0.5),
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }
}
