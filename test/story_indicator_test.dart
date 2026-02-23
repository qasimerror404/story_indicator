import 'package:flutter_test/flutter_test.dart';
import 'package:story_progress_indicator/src/story_indicator_math.dart';

void main() {
  group('segmentFill', () {
    test('progress 0.0 index 0 => 0.0', () {
      expect(segmentFill(index: 0, progress: 0.0), closeTo(0.0, 1e-10));
    });
    test('progress 0.5 index 0 => 0.5', () {
      expect(segmentFill(index: 0, progress: 0.5), closeTo(0.5, 1e-10));
    });
    test('progress 1.0 index 1 => 0.0', () {
      expect(segmentFill(index: 1, progress: 1.0), closeTo(0.0, 1e-10));
    });
    test('progress 2.3 index 0 => 1.0', () {
      expect(segmentFill(index: 0, progress: 2.3), closeTo(1.0, 1e-10));
    });
    test('progress 2.3 index 1 => 1.0', () {
      expect(segmentFill(index: 1, progress: 2.3), closeTo(1.0, 1e-10));
    });
    test('progress 2.3 index 2 => 0.3', () {
      expect(segmentFill(index: 2, progress: 2.3), closeTo(0.3, 1e-10));
    });
    test('progress 2.3 index 3 => 0.0', () {
      expect(segmentFill(index: 3, progress: 2.3), closeTo(0.0, 1e-10));
    });
    test('progress 0.0 index 1 => 0.0', () {
      expect(segmentFill(index: 1, progress: 0.0), closeTo(0.0, 1e-10));
    });
    test('progress 3.0 index 2 => 1.0', () {
      expect(segmentFill(index: 2, progress: 3.0), closeTo(1.0, 1e-10));
    });
  });
}
