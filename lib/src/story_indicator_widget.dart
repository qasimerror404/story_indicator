// story_indicator_widget.dart - main widget

import 'package:flutter/material.dart';

import 'story_indicator_math.dart';
import 'story_indicator_segment.dart';

/// A Stories-style segmented progress indicator with timed, swipeable support.
///
/// Progress is driven entirely by the parent via [progress] (0 → [count],
/// fractional values allowed). No internal animation or setState.
class StoryIndicator extends StatelessWidget {
  /// Creates a [StoryIndicator].
  ///
  /// [count] must be > 0, [progress] >= 0, [height] > 0, [gap] >= 0.
  const StoryIndicator({
    super.key,
    required this.count,
    required this.progress,
    this.height = 4.0,
    this.gap = 4.0,
    this.trackColor = const Color(0x33FFFFFF),
    this.fillColor = const Color(0xFFFFFFFF),
    this.radius = const BorderRadius.all(Radius.circular(100)),
  });

  /// Number of segments.
  final int count;

  /// Current progress in segment units (0 to [count], fractional OK).
  final double progress;

  /// Segment height in logical pixels.
  final double height;

  /// Gap between segments in logical pixels.
  final double gap;

  /// Color of the unfilled track.
  final Color trackColor;

  /// Color of the filled portion.
  final Color fillColor;

  /// Corner radius for each segment.
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    assert(count > 0, 'StoryIndicator count must be > 0');
    assert(progress >= 0.0, 'StoryIndicator progress must be >= 0.0');
    assert(height > 0, 'StoryIndicator height must be > 0');
    assert(gap >= 0, 'StoryIndicator gap must be >= 0');

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final segmentWidth = (maxWidth - gap * (count - 1)) / count;
        final clampedSegmentWidth = segmentWidth.clamp(0.0, double.infinity);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (index) {
            final fill = segmentFill(index: index, progress: progress);
            return IndicatorSegment(
              fillFactor: fill,
              width: clampedSegmentWidth,
              height: height,
              trackColor: trackColor,
              fillColor: fillColor,
              radius: radius,
            );
          }),
        );
      },
    );
  }
}
