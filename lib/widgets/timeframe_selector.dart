import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:timeframe_selector/common.dart';
import 'package:timeframe_selector/widgets/blocked_period_overlay.dart';
import 'package:timeframe_selector/widgets/timeframe_segment.dart';
import 'package:timeframe_selector/widgets/timeframe_selection_overlay.dart';

class TimeframeSelector extends StatelessWidget {
  const TimeframeSelector({
    required this.baseTimeframe,
    required this.timeSegmentLength,
    this.minTimeframeSegments = 1,
    this.segmentHeight = 50,
    this.blockedTimeframes = const [],
    this.blockedTimeframeBuffer = 0,
    this.noSelectionText = '',
    required this.selectedTimeframe,
    required this.onTimeframeChange,
    this.validator,
    super.key,
  });

  ///The time range in which a selection can be made
  final DateTimeRange baseTimeframe;

  ///The length of one segment in minutes
  final Duration timeSegmentLength;

  ///The minimum amount of segments that can make up a selection
  final int minTimeframeSegments;

  ///The height of one segment
  final double segmentHeight;

  ///A list of [DateTimeRange]s that cannot be selected
  final Iterable<DateTimeRange> blockedTimeframes;

  ///The amount of buffer segments that will be added before and after any blocked timeframe
  final int blockedTimeframeBuffer;

  ///The text that will be displayed while no selection has been made
  final String noSelectionText;

  ///The selected timeframe that will be displayed
  final DateTimeRange? selectedTimeframe;

  final void Function(DateTimeRange? newTimeframe) onTimeframeChange;
  final String? Function(DateTimeRange? timeframe)? validator;

  Set<Set<int>> getBlockedSegments(int timeSegmentCount) {
    final Set<Set<int>> blockedSegmentsTemp = {};

    for (final blockedTimeframe in blockedTimeframes) {
      final startSegement = timeframeSegmentDifference(
        endDateTime: toTime(blockedTimeframe.start),
      );
      final blockLength = timeframeSegmentDifference(
        endDateTime: blockedTimeframe.end,
        startDateTime: blockedTimeframe.start,
      );

      int startIndex = startSegement;
      int lenght = blockLength;

      if (startIndex != 0) {
        startIndex = startSegement - blockedTimeframeBuffer;
        lenght++;
      }

      if (startIndex + lenght < timeSegmentCount - 1) {
        lenght += blockedTimeframeBuffer;
      }

      final newValues = List.generate(
        lenght,
        (index) => startIndex + index,
      );

      final aggregate = blockedSegmentsTemp.firstWhereOrNull(
        (element) =>
            element.contains(startIndex) ||
            element.contains(startIndex + lenght),
      );

      if (aggregate != null) {
        aggregate.addAll(newValues);
        continue;
      }

      blockedSegmentsTemp.add(Set.from(newValues));
    }

    return blockedSegmentsTemp;
  }

  int timeframeSegmentDifference({
    required DateTime endDateTime,
    DateTime? startDateTime,
  }) {
    return endDateTime
            .difference(
              startDateTime ?? baseTimeframe.start,
            )
            .inMinutes ~/
        timeSegmentLength.inMinutes;
  }

  String? getTimeframeString(DateTimeRange? timeframe) {
    if (timeframe != null) {
      return timeRangeToString(
        timeframe,
      );
    }
    return null;
  }

  List<Widget> getTimeSegments(
    int timeSegmentCount,
    Set<int> blockedSegments,
  ) {
    return List.generate(
      timeSegmentCount,
      (index) {
        final currentDate = baseTimeframe.start.add(
          timeSegmentLength * index,
        );
        final isFullHour = currentDate.minute == 0;

        BorderRadius? borderRadius;

        if (index == 0) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          );
        } else if (index == timeSegmentCount - 1) {
          borderRadius = const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          );
        }

        final isBlocked = blockedSegments.contains(index);

        return TimeframeSegment(
          isBlocked: isBlocked,
          index: index,
          segmentHeight: segmentHeight,
          borderRadius: borderRadius,
          onTap: () {
            if (!isBlocked) {
              int potentialIndex = index;

              while (potentialIndex >= 0) {
                if (blockedSegments.contains(potentialIndex)) {
                  return;
                }

                if (checkBaseConstraints(
                  newIndex: potentialIndex,
                  newCount: minTimeframeSegments,
                  timeSegmentCount: timeSegmentCount,
                  blockedSegments: blockedSegments,
                )) {
                  break;
                }
                potentialIndex--;
              }

              onTimeframeChange(
                getTimeframe(
                  newIndex: potentialIndex,
                  newCount: minTimeframeSegments,
                ),
              );
            }
          },
          timeWidget: isFullHour
              ? Center(
                  child: Text(
                    hourDateFormat.format(currentDate),
                  ),
                )
              : null,
        );
      },
    );
  }

  bool checkBaseConstraints({
    required int newIndex,
    required int newCount,
    required int timeSegmentCount,
    required Set<int> blockedSegments,
  }) {
    if (newIndex < 0 ||
        newIndex + newCount > timeSegmentCount ||
        newCount < minTimeframeSegments) {
      return false;
    }

    if (blockedSegments.contains(newIndex) ||
        blockedSegments.contains(newIndex + newCount - 1)) {
      return false;
    }

    return true;
  }

  DateTimeRange? getTimeframe({
    required int newIndex,
    required int newCount,
  }) {
    final startTime = baseTimeframe.start.add(
      timeSegmentLength * newIndex,
    );

    final endTime = startTime.add(timeSegmentLength * newCount);

    return DateTimeRange(
      start: DateTime(
        baseTimeframe.start.year,
        baseTimeframe.start.month,
        baseTimeframe.start.day,
        startTime.hour,
        startTime.minute,
      ),
      end: DateTime(
        baseTimeframe.start.year,
        baseTimeframe.start.month,
        baseTimeframe.start.day + endTime.day - 1,
        endTime.hour,
        endTime.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeSegmentCount =
        timeframeSegmentDifference(endDateTime: baseTimeframe.end);

    final blockedSegments = getBlockedSegments(timeSegmentCount);
    final expandedBlockedSegments = blockedSegments
        .expand(
          (element) => element,
        )
        .toSet();

    final timeSegments = getTimeSegments(
      timeSegmentCount,
      expandedBlockedSegments,
    );

    final selectedTimeframeIndex = selectedTimeframe == null
        ? 0
        : timeframeSegmentDifference(
            endDateTime: selectedTimeframe!.start,
          );

    final selectedTimeframeCount = selectedTimeframe == null
        ? 0
        : timeframeSegmentDifference(
            endDateTime: selectedTimeframe!.end,
            startDateTime: selectedTimeframe!.start,
          );

    final cleanSelectedTimeframe = checkBaseConstraints(
      newIndex: selectedTimeframeIndex,
      newCount: selectedTimeframeCount,
      timeSegmentCount: timeSegmentCount,
      blockedSegments: expandedBlockedSegments,
    )
        ? getTimeframe(
            newIndex: selectedTimeframeIndex,
            newCount: selectedTimeframeCount,
          )
        : null;

    return FormField(
      validator: (value) => validator?.call(cleanSelectedTimeframe),
      builder: (state) => Column(
        children: [
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.errorText!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                getTimeframeString(cleanSelectedTimeframe) ?? noSelectionText),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 5,
                  blurRadius: 7,
                )
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Column(
                  children: timeSegments,
                ),
                BlockedPeriodOverlay(
                  verticalSegmentHeight: segmentHeight,
                  blockedSegments: blockedSegments,
                ),
                if (selectedTimeframe != null)
                  TimeframeSelectionOverlay(
                    verticalSegmentHeight: segmentHeight,
                    selectedIndex: selectedTimeframeIndex,
                    selectedCount: selectedTimeframeCount,
                    updateSelection: (newIndex, newCount) {
                      if (checkBaseConstraints(
                        newIndex: newIndex,
                        newCount: newCount,
                        timeSegmentCount: timeSegmentCount,
                        blockedSegments: expandedBlockedSegments,
                      )) {
                        onTimeframeChange(
                          getTimeframe(
                            newIndex: newIndex,
                            newCount: newCount,
                          ),
                        );
                      }
                    },
                    resetSelection: () => onTimeframeChange(null),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
