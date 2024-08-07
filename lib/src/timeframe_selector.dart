import 'package:flutter/material.dart';
import 'package:timeframe_selector/src/blocked_period_overlay.dart';
import 'package:timeframe_selector/src/common.dart';
import 'package:timeframe_selector/src/overlay_data.dart';
import 'package:timeframe_selector/src/timeframe_segment.dart';
import 'package:timeframe_selector/src/timeframe_selection_overlay.dart';

class TimeframeSelector extends StatelessWidget {
  const TimeframeSelector({
    required this.baseTimeframe,
    required this.timeSegmentLength,
    this.minTimeframeSegments = 1,
    this.segmentHeight = 50,
    this.overlayDatas = const [],
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

  ///A list of [OverlayData] to be shown in the timeframe selection
  final Iterable<OverlayData> overlayDatas;

  ///The text that will be displayed while no selection has been made
  final String noSelectionText;

  ///The selected timeframe that will be displayed
  final DateTimeRange? selectedTimeframe;

  final void Function(DateTimeRange? newTimeframe) onTimeframeChange;
  final String? Function(DateTimeRange? timeframe)? validator;

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
    final timeSegmentCount = timeframeSegmentDifference(
      endDateTime: baseTimeframe.end,
      startDateTime: baseTimeframe.start,
      timeSegmentLength: timeSegmentLength,
    );

    final allBlockedSegments = overlayDatas
        .where(
          (element) => element.blockSelection,
        )
        .map(
          (e) => e.getSegments(
            timeSegmentCount,
            baseTimeframe,
            timeSegmentLength,
          ),
        )
        .expand(
          (element) => element.expand(
            (element) => element,
          ),
        )
        .toSet();

    final timeSegments = getTimeSegments(
      timeSegmentCount,
      allBlockedSegments,
    );

    final selectedTimeframeIndex = selectedTimeframe == null
        ? 0
        : timeframeSegmentDifference(
            endDateTime: selectedTimeframe!.start,
            startDateTime: baseTimeframe.start,
            timeSegmentLength: timeSegmentLength,
          );

    final selectedTimeframeCount = selectedTimeframe == null
        ? 0
        : timeframeSegmentDifference(
            endDateTime: selectedTimeframe!.end,
            startDateTime: selectedTimeframe!.start,
            timeSegmentLength: timeSegmentLength,
          );

    final cleanSelectedTimeframe = checkBaseConstraints(
      newIndex: selectedTimeframeIndex,
      newCount: selectedTimeframeCount,
      timeSegmentCount: timeSegmentCount,
      blockedSegments: allBlockedSegments,
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
                for (final overlayData in overlayDatas)
                  TimeFrameOverlay(
                    timeSegmentCount: timeSegmentCount,
                    baseTimeframe: baseTimeframe,
                    timeSegmentLength: timeSegmentLength,
                    verticalSegmentHeight: segmentHeight,
                    overlayData: overlayData,
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
                        blockedSegments: allBlockedSegments,
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
