import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class BlockedPeriodOverlay extends StatelessWidget {
  const BlockedPeriodOverlay({
    required this.verticalSegmentHeight,
    required this.blockedSegments,
    super.key,
  });
  final double verticalSegmentHeight;
  final Set<Set<int>> blockedSegments;

  @override
  Widget build(BuildContext context) {
    final overlays = blockedSegments.map(
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
