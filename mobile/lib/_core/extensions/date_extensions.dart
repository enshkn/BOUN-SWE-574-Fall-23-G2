import '../helpers/datetime_helper.dart';

extension DateExtensions on DateTime {
  String get getDateStr =>
      "${day.toString().padLeft(2, "0")}.${month.toString().padLeft(2, "0")}.$year";
  String get getCurrentDay => getDay(weekday);
  String get getHHmm =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ";

  String get getDateWithMonthName =>
      "${day.toString().padLeft(2, "0")} ${getMonth(month)}, $year";
  String get getDateWithMonthNameWithoutYear =>
      "${day.toString().padLeft(2, "0")} ${getMonth(month)}";
  String get getDateTimeStr => '$getDateStr $getHHmm';

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }
}
