import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'overlay_data.dart';

class TimeFrameOverlay extends StatelessWidget {
  const TimeFrameOverlay({
    required this.verticalSegmentHeight,
    required this.overlayData,
    super.key,
  });
  final double verticalSegmentHeight;
  final OverlayData overlayData;

  @override
  Widget build(BuildContext context) {
    final overlays = overlayData.map(
      (e) {
        final sortedBlock = e.sorted(
          (a, b) => a.compareTo(b),
        );
        return Column(
          children: [
            SizedBox(
              height: verticalSegmentHeight * sortedBlock.first,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                border: Border.all(
                  color: Colors.red.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              height: verticalSegmentHeight * sortedBlock.length,
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
