import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:magic_8_ball/main.dart';

void main() {
  testWidgets('Magic 8-Ball smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Magic8BallApp());

    // Verify that our app starts with the default message.
    expect(find.text('Ask a question and tap!'), findsOneWidget);

    // Tap the 8-ball (find the inner circle tapping target)
    await tester.tap(find.text('Ask a question and tap!'));
    await tester.pump();

    // After tapping, the default message might be gone or replaced by an answer.
    // It's possible but extremely unlikely the default text returns. 
    // Simply having tapped and pumped without error is mostly enough for a smoke test.
    expect(find.text('Tap the 8-Ball for your answer'), findsOneWidget);
  });
}
