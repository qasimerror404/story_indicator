// story_indicator_segment.dart - private segment widget

import 'package:flutter/material.dart';

/// Internal segment widget. Fill is driven entirely by [fillFactor] from parent.
/// No animation or setState inside.
@immutable
class IndicatorSegment extends StatelessWidget {
  const IndicatorSegment({
    super.key,
    required this.fillFactor,
    required this.width,
    required this.height,
    required this.trackColor,
    required this.fillColor,
    required this.radius,
  });

  final double fillFactor;
  final double width;
  final double height;
  final Color trackColor;
  final Color fillColor;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: trackColor),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fillFactor,
                  child: Container(color: fillColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
