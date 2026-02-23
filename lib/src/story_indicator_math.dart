// story_indicator_math.dart - pure math helper

/// Returns the fill factor (0.0 to 1.0) for a segment at [index]
/// given the current [progress] value.
double segmentFill({required int index, required double progress}) {
  final base = progress.floor();
  final fraction = progress - base;

  if (index < base) return 1.0;
  if (index == base) return fraction.clamp(0.0, 1.0);
  return 0.0;
}
