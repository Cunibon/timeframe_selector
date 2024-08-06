import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final hourDateFormat = DateFormat.Hm();

String timeRangeToString(DateTimeRange timeRange) {
  final startString = hourDateFormat.format(
    timeRange.start,
  );
  final endString = hourDateFormat.format(
    timeRange.end,
  );
  return "$startString - $endString";
}

DateTime toTime(DateTime dateTime) {
  return DateTime(
    0,
    1,
    1,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );
}
