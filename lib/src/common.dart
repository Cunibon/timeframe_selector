import 'package:intl/intl.dart';

final hourDateFormat = DateFormat.Hm();

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
