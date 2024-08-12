import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'overlay_data.dart';

class TimeFrameOverlay extends StatelessWidget {
  const TimeFrameOverlay({
    required this.verticalSegmentHeight,
    required this.overlayData,
    required this.timeSegmentCount,
    required this.baseTimeframe,
    required this.timeSegmentLength,
    super.key,
  });
  final double verticalSegmentHeight;
  final OverlayData overlayData;
  final int timeSegmentCount;
  final DateTimeRange baseTimeframe;
  final Duration timeSegmentLength;

  @override
  Widget build(BuildContext context) {
    final segments = overlayData.getSegments(
      timeSegmentCount,
      baseTimeframe,
      timeSegmentLength,
    );

    final overlays = segments.map(
      (e) {
        final sortedBlock = e.sorted(
          (a, b) => a.compareTo(b),
        );
        return Column(
          children: [
            SizedBox(
              height: verticalSegmentHeight * sortedBlock.first,
            ),
            GestureDetector(
              onTap:
                  overlayData.onTap == null ? null : () => overlayData.onTap!(),
              child: Container(
                decoration: BoxDecoration(
                  color: overlayData.color,
                  border: Border.all(
                    color: overlayData.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: verticalSegmentHeight * sortedBlock.length,
                child: overlayData.child == null
                    ? null
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 74,
                          ),
                          overlayData.child!
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );

    return Stack(
      children: overlays.toList(),
    );
  }
}
