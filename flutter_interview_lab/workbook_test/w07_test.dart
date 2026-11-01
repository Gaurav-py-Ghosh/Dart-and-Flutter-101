import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w07.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('1 TapCounter', (tester) async {
    await tester.pumpWidget(wrap(const TapCounter()));
    expect(find.text('Tapped 0 times'), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('Tapped 1 times'), findsOneWidget);
  });

  testWidgets('2 ShowHide', (tester) async {
    await tester.pumpWidget(wrap(const ShowHide()));
    expect(find.text('Secret'), findsNothing);
    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.text('Secret'), findsOneWidget);
    await tester.tap(find.text('Hide'));
    await tester.pump();
    expect(find.text('Secret'), findsNothing);
  });

  testWidgets('3 Countdown counts, stops, and cancels', (tester) async {
    await tester.pumpWidget(wrap(const Countdown(seconds: 2)));
    expect(find.text('2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('0'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(wrap(const Countdown(seconds: 9)));
    // Removing it must cancel its timer, or this test reports a pending timer.
    await tester.pumpWidget(wrap(const SizedBox()));
  });

  testWidgets('4 ValueWatcher', (tester) async {
    final changes = <String>[];
    void record(int oldValue, int newValue) =>
        changes.add('$oldValue to $newValue');

    await tester.pumpWidget(wrap(ValueWatcher(value: 1, onChanged: record)));
    await tester.pumpWidget(wrap(ValueWatcher(value: 1, onChanged: record)));
    expect(changes, isEmpty);
    await tester.pumpWidget(wrap(ValueWatcher(value: 2, onChanged: record)));
    expect(changes, ['1 to 2']);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('5 EchoField', (tester) async {
    await tester.pumpWidget(wrap(const EchoField()));
    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    expect(find.text('You typed: hello'), findsOneWidget);
  });

  testWidgets('6 SlowLoader survives being removed', (tester) async {
    await tester.pumpWidget(wrap(SlowLoader(load: () async => 'Done')));
    expect(find.text('Loading'), findsOneWidget);
    await tester.pump();
    expect(find.text('Done'), findsOneWidget);

    final completer = Completer<String>();
    await tester.pumpWidget(wrap(const SizedBox()));
    await tester.pumpWidget(wrap(SlowLoader(load: () => completer.future)));
    await tester.pumpWidget(wrap(const SizedBox()));
    completer.complete('Too late');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('7 KeyedNames keeps taps with the name', (tester) async {
    await tester.pumpWidget(wrap(const KeyedNames(names: ['A', 'B'])));
    await tester.tap(find.byType(TextButton).first);
    await tester.pump();
    expect(find.text('Tapped 1 times'), findsOneWidget);

    await tester.pumpWidget(wrap(const KeyedNames(names: ['B', 'A'])));
    final buttons = find.byType(TextButton);
    expect(
      find.descendant(of: buttons.last, matching: find.text('Tapped 1 times')),
      findsOneWidget,
    );
  });
}
