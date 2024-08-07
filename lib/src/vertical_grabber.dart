import 'package:flutter/material.dart';

class VerticalGrabber extends StatelessWidget {
  const VerticalGrabber({
    required this.color,
    this.width = 20,
    this.height = 20,
    this.borderRadius,
    this.margin = const EdgeInsets.all(8),
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    super.key,
  });

  final Color color;

  final double width;
  final double height;

  final EdgeInsets margin;

  final Function(DragUpdateDetails updateDetails)? onVerticalDragUpdate;
  final Function(DragEndDetails endDetails)? onVerticalDragEnd;

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
