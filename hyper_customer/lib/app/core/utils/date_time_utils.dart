import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String currentTimeAdd({int? second}) {
    initializeDateFormatting();
    var today = DateTime.now();
    var addSecond = today.add(Duration(seconds: second ?? 0));
    return DateFormat('HH:mm').format(addSecond);
  }

  static DateTime? stringToDateTimeFixUTC(String? value) {
    return DateTime.tryParse(value ?? '')?.add(const Duration(hours: 7));
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

  static String dateTimeToStringAPI(DateTime? dateTime) {
    initializeDateFormatting();
    return dateTime == null ? '-' : DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime? parseDateTime(int? timestamp) {
    return timestamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static DateTime? parseDateTimeDouble(double? timestamp) {
    if (timestamp == null) return null;
    int value = int.parse((timestamp * 1000).toStringAsFixed(0));
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static DateTime? formCCCD(String value) {
    int day = int.parse(value.substring(0, 2));
    int month = int.parse(value.substring(2, 4));
    int year = int.parse(value.substring(4, 8));
    return DateTime(year, month, day);
  }

  static bool compare(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('$days ngày, ');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours.toString().padLeft(2, '0')}:');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes.toString().padLeft(2, '0')}:');
    }
    tokens.add(seconds.toString().padLeft(2, '0'));

    return tokens.join();
  }

  static String formatDurationOnlyDayAndHour(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('$days ngày, ');
    }
    if (hours != 0) {
      tokens.add('$hours giờ');
    }

    return tokens.join();
  }

  static String counter(double? timeStamp) {
    var dateTime = parseDateTimeDouble(timeStamp);
    var duration = dateTime?.difference(DateTime.now());
    if (duration == null) return '-';
    return formatDuration(duration);
  }

  static String counterDateTime(DateTime? dateTime) {
    var duration = dateTime?.difference(DateTime.now());
    if (duration == null) return '-';
    return formatDuration(duration);
  }

  static String hoursToString(int hours) {
    var duration = Duration(hours: hours);
    return formatDurationOnlyDayAndHour(duration);
  }

  static String daysToString(int days) {
    var duration = Duration(days: days);
    return formatDurationOnlyDayAndHour(duration);
  }
}
