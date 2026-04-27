import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment03/main.dart';

void main() {
  testWidgets('shows BMI calculator home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiApp());

    expect(find.text('Calculate BMI'), findsOneWidget);
    expect(find.text('Height (cm)'), findsOneWidget);
    expect(find.text('Weight (kg)'), findsOneWidget);
  });

  testWidgets('shows validation page for empty submit', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiApp());

    await tester.ensureVisible(find.text('Calculate BMI'));
    await tester.tap(find.text('Calculate BMI'));
    await tester.pumpAndSettle();

    expect(find.text('Please check your inputs'), findsOneWidget);
    expect(find.text('Go back and edit'), findsOneWidget);
  });

  testWidgets('navigates to bmi result page', (WidgetTester tester) async {
    await tester.pumpWidget(const BmiApp());

    await tester.enterText(find.byType(TextFormField).at(0), '170');
    await tester.enterText(find.byType(TextFormField).at(1), '65');
    await tester.ensureVisible(find.text('Calculate BMI'));
    await tester.tap(find.text('Calculate BMI'));
    await tester.pumpAndSettle();

    expect(find.text('BMI Result'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
  });
}
