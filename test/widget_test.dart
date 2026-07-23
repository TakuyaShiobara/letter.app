import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:letter_app/app.dart';

void main() {
  testWidgets('Home screen shows the hero copy and category grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LetterApp());
    await tester.pumpAndSettle();

    expect(find.text('想いを、\n言葉に。'), findsOneWidget);
    expect(find.text('お礼'), findsWidgets);

    await tester.dragUntilVisible(
      find.text('人気の文例'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    expect(find.text('人気の文例'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between the three tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LetterApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('文例'));
    await tester.pumpAndSettle();
    expect(find.text('文例一覧'), findsOneWidget);

    await tester.tap(find.text('作成'));
    await tester.pumpAndSettle();
    expect(find.text('手紙を作成'), findsOneWidget);
  });
}
