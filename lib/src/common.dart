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

int timeframeSegmentDifference({
  required DateTime endDateTime,
  required DateTime startDateTime,
  required Duration timeSegmentLength,
}) {
  return endDateTime
          .difference(
            startDateTime,
          )
          .inMinutes ~/
      timeSegmentLength.inMinutes;
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
