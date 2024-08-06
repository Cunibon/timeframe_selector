import 'package:flutter/material.dart';

class TimeframeSegment extends StatelessWidget {
  const TimeframeSegment({
    required this.isBlocked,
    required this.index,
    required this.segmentHeight,
    required this.onTap,
    this.timeWidget,
    this.borderRadius,
    super.key,
  });

  final bool isBlocked;
  final int index;
  final BorderRadiusGeometry? borderRadius;
  final double segmentHeight;
  final Widget? timeWidget;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? Colors.white
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: borderRadius,
        ),
        height: segmentHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: segmentHeight,
                    child: timeWidget,
                  ),
                  const VerticalDivider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
