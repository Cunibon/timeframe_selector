import 'package:flutter/material.dart';

class OverlayData {
  OverlayData({
   this.color = Colors.red.withOpacity(0.2),
   this.borderColor = Colors.red.withOpacity(0.4),
   required this.timeframes,
   this.onTap,
   this.blockSelection = true,
   this.aggregate = true,
   this.child,
  });

  final Color color;
  final Color borderColor;
  final Iterable<DateTimeRange> timeframes;
  final void Function(Iterable<DateTimeRange> ranges)? onTap;
  final bool blockSelection;
  final bool aggregate;  
  final Widget (Iterable<DateTimeRange> ranges)? child;
}
