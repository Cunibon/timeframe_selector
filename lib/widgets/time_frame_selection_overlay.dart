import 'package:flutter/material.dart';
import 'package:timeframe_selector/widgets/vertical_grabber.dart';

class TimeframeSelectionOverlay extends StatelessWidget {
  const TimeframeSelectionOverlay({
    required this.verticalSegmentHeight,
    required this.selectedIndex,
    required this.selectedCount,
    required this.updateSelection,
    required this.resetSelection,
    super.key,
  });

  static const circularRadius = Radius.circular(8);

  final double verticalSegmentHeight;

  final int selectedIndex;
  final int selectedCount;

  final void Function(int newIndex, int newCount) updateSelection;
  final void Function() resetSelection;

  @override
  Widget build(BuildContext context) {
    double verticalDiff = 0;

    return Column(
      children: [
        SizedBox(
          height: verticalSegmentHeight * selectedIndex,
        ),
        Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                verticalDiff -= details.delta.dy;
                if (verticalDiff >= verticalSegmentHeight) {
                  updateSelection(selectedIndex - 1, selectedCount);
                } else if (verticalDiff <= -verticalSegmentHeight) {
                  updateSelection(selectedIndex + 1, selectedCount);
                }
              },
              onVerticalDragEnd: (details) => verticalDiff = 0,
              onTap: resetSelection,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: verticalSegmentHeight * selectedCount,
              ),
            ),
            Positioned(
              top: 0,
              left: 78,
              child: VerticalGrabber(
                color: Colors.blueAccent,
                height: 10,
                borderRadius: const BorderRadius.only(
                  bottomLeft: circularRadius,
                  bottomRight: circularRadius,
                ),
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                onVerticalDragUpdate: (details) {
                  verticalDiff -= details.delta.dy;
                  if (verticalDiff >= verticalSegmentHeight) {
                    updateSelection(selectedIndex - 1, selectedCount + 1);
                  } else if (verticalDiff <= -verticalSegmentHeight) {
                    updateSelection(selectedIndex + 1, selectedCount - 1);
                  }
                },
                onVerticalDragEnd: (details) => verticalDiff = 0,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 12,
              child: VerticalGrabber(
                color: Colors.blueAccent,
                height: 10,
                borderRadius: const BorderRadius.only(
                  topLeft: circularRadius,
                  topRight: circularRadius,
                ),
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                onVerticalDragUpdate: (details) {
                  verticalDiff -= details.delta.dy;
                  if (verticalDiff >= verticalSegmentHeight) {
                    updateSelection(selectedIndex, selectedCount - 1);
                  } else if (verticalDiff <= -verticalSegmentHeight) {
                    updateSelection(selectedIndex, selectedCount + 1);
                  }
                },
                onVerticalDragEnd: (details) => verticalDiff = 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
