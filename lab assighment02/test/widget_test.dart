import 'package:flutter_test/flutter_test.dart';

import 'package:lab_assignment02/main.dart';

void main() {
  testWidgets('Home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const NumberGuessingGameApp());

    expect(find.text('Number Guessing Game'), findsOneWidget);
    expect(find.text('Guess a number from 1 to 100'), findsOneWidget);
    expect(find.text('Check Guess'), findsOneWidget);
  });
}
