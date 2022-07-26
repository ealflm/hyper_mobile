import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String currentTimeAdd({int? second}) {
    initializeDateFormatting();
    var today = DateTime.now();
    var addSecond = today.add(Duration(seconds: second ?? 0));
    return DateFormat('HH:mm').format(addSecond);
  }

  static String? dateTimeToString(DateTime? dateTime) {
    initializeDateFormatting();
    return dateTime == null
        ? null
        : DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }
}