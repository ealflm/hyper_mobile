import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String currentTimeAdd({int? second}) {
    initializeDateFormatting();
    var today = DateTime.now();
    var addSecond = today.add(Duration(seconds: second ?? 0));
    return DateFormat('HH:mm').format(addSecond);
  }

  static String dateTimeToString(DateTime? dateTime) {
    initializeDateFormatting();
    return dateTime == null
        ? '-'
        : DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }

  static String dateTimeToStringFixUTC(DateTime? dateTime) {
    initializeDateFormatting();
    if (dateTime == null) return '-';
    dateTime = dateTime.add(const Duration(hours: 7));
    return DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
  }

  static DateTime? parseDateTime(int? timestamp) {
    return timestamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static DateTime? formCCCD(String value) {
    int day = int.parse(value.substring(0, 2));
    int month = int.parse(value.substring(2, 4));
    int year = int.parse(value.substring(4, 8));
    return DateTime(year, month, day);
  }
}
