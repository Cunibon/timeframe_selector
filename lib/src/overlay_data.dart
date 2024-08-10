import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:timeframe_selector/src/common.dart';

class OverlayData {
  OverlayData({
    Color? color,
    Color? borderColor,
    required this.timeframes,
    this.timeframeBuffer = 0,
    this.onTap,
    this.blockSelection = true,
    this.aggregate = true,
    this.child,
  })  : color = color ?? Colors.red.withOpacity(0.2),
        borderColor = borderColor ?? Colors.red.withOpacity(0.4);

  ///The main color of the overlay widget
  final Color color;

  ///The border color of the overlay widget
  final Color borderColor;

  ///All timeframes that this overlay will apply
  final Iterable<DateTimeRange> timeframes;

  ///The amount of buffer segments that will be added before and after each timeframe
  final int timeframeBuffer;
  final void Function()? onTap;

  ///A child widget that can be displayed by this overlay
  final Widget? child;

  ///If this overlay will block any selection being made on the underlying segments
  final bool blockSelection;

  ///If the timeframes will be aggregated to avoid intersections
  final bool aggregate;

  Set<Set<int>> getSegments(
    int timeSegmentCount,
    DateTimeRange baseTimeframe,
    Duration timeSegmentLength,
  ) {
    final Set<Set<int>> blockedSegmentsTemp = {};

    for (final timeframe in timeframes) {
      final startSegement = timeframeSegmentDifference(
        endDateTime: toTime(timeframe.start),
        startDateTime: baseTimeframe.start,
        timeSegmentLength: timeSegmentLength,
      );
      final blockLength = timeframeSegmentDifference(
        endDateTime: timeframe.end,
        startDateTime: timeframe.start,
        timeSegmentLength: timeSegmentLength,
      );

      int startIndex = startSegement;
      int lenght = blockLength;

      if (startIndex != 0) {
        startIndex = startSegement - timeframeBuffer;
        lenght += timeframeBuffer;
      }

      if (startIndex + lenght < timeSegmentCount - 1) {
        lenght += timeframeBuffer;
      }

      final newValues = List.generate(
        lenght,
        (index) => startIndex + index,
      );

      if (aggregate) {
        final aggregation = blockedSegmentsTemp.firstWhereOrNull(
          (element) =>
              element.contains(startIndex) ||
              element.contains(startIndex + lenght),
        );

        if (aggregation != null) {
          aggregation.addAll(newValues);
          continue;
        }
      }

      blockedSegmentsTemp.add(Set.from(newValues));
    }

    return blockedSegmentsTemp;
  }
}
