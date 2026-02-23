// Basic Flutter widget test for the story indicator example app.

import 'package:flutter_test/flutter_test.dart';
import 'package:story_progress_indicator/main.dart';

void main() {
  testWidgets('Stories viewer loads and shows first story', (WidgetTester tester) async {
    await tester.pumpWidget(const StoryIndicatorExampleApp());

    expect(find.text('Northern Lights Tonight'), findsOneWidget);
    expect(find.text('@aurora'), findsOneWidget);
  });
}
