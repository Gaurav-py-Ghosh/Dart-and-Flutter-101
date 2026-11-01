// Run with:  flutter test test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/labs/app_labs.dart';
import 'package:flutter_interview_lab/labs/state_labs.dart';
import 'package:flutter_interview_lab/labs/ui_labs.dart';
import 'package:flutter_interview_lab/main.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('the menu lists the labs and opens one', (tester) async {
    await tester.pumpWidget(const LabApp());
    expect(find.text('Layout'), findsOneWidget);
    await tester.tap(find.text('Forms'));
    await tester.pumpAndSettle();
    expect(find.text('Submit'), findsOneWidget);
  });

  // Every state management version must behave the same way.
  final counters = <String, Widget>{
    'setState': const SetStateCounter(),
    'ValueNotifier': const NotifierCounter(),
    'InheritedWidget': const InheritedCounter(),
    'Provider': const ProviderCounter(),
    'Riverpod': const RiverpodCounter(),
    'Cubit': const CubitCounter(),
    'Bloc': const BlocCounter(),
  };
  counters.forEach((name, counter) {
    testWidgets('$name counter goes from 0 to 2', (tester) async {
      await tester.pumpWidget(wrap(counter));
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });

  testWidgets('the form shows errors, then accepts a real email', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const FormLab()));

    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('email')), 'nope');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('That is not an email'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('email')), 'a@b.com');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Welcome a@b.com'), findsOneWidget);
  });

  testWidgets('Navigator returns a value from the second page', (tester) async {
    await tester.pumpWidget(wrap(const NavigatorLab()));
    await tester.tap(find.text('Open page'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose Mango and go back'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mango'), findsOneWidget);
  });

  testWidgets('debounce waits until typing stops', (tester) async {
    await tester.pumpWidget(wrap(const SearchLab()));
    expect(find.text('Showing 20 of 200'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('search')), 'Item 19');
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Showing 20 of 200'), findsOneWidget); // too early

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Showing 11 of 11'), findsOneWidget); // 19, and 190-199
  });

  testWidgets('scrolling near the bottom loads the next page', (tester) async {
    await tester.pumpWidget(wrap(const SearchLab()));
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();
    expect(find.textContaining('Showing 40'), findsOneWidget);
  });

  testWidgets('a ValueKey keeps state with the right item', (tester) async {
    await tester.pumpWidget(wrap(const KeysLab()));
    // Boxes 4, 5 and 6 are the keyed ones. Box 4 belongs to Asha.
    await tester.enterText(find.byType(TextField).at(3), 'typed by Asha');
    await tester.tap(find.text('Rotate'));
    await tester.pump();

    // Rotating gives Meera, Asha, Ravi. Asha's box has moved to second place.
    final second = tester.widget<TextField>(find.byType(TextField).at(4));
    expect(second.decoration?.labelText, 'Asha');
    expect(second.controller?.text, 'typed by Asha');
  });

  testWidgets('without a key, typed text stays behind', (tester) async {
    await tester.pumpWidget(wrap(const KeysLab()));
    await tester.enterText(find.byType(TextField).at(0), 'typed by Asha');
    await tester.tap(find.text('Rotate'));
    await tester.pump();

    // The first box is now labelled Meera, but it still holds Asha's text.
    final first = tester.widget<TextField>(find.byType(TextField).at(0));
    expect(first.decoration?.labelText, 'Meera');
    expect(first.controller?.text, 'typed by Asha');
  });
}
