// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sensorprjct/main.dart';

void main() {
  testWidgets('Button goes to second screen', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: "Today's Temperature")));

    expect(find.byKey(const Key('SwitchKey')), findsNWidgets(1));

    await tester.tap(find.byKey(Key('SwitchKey')));

    await tester.pump();
    await tester.pump();
    expect(find.byType(SecondRoute), findsOneWidget);
  });

  testWidgets('Button on second screen goes back to first screen',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: SecondRoute()));

    expect(find.byKey(const Key('2ndKey')), findsNWidgets(1));

    await tester.tap(find.byKey(Key('2ndKey')));

    await tester.pump();
    await tester.pump();
    expect(find.byType(SecondRoute), findsOneWidget);
  });
}
