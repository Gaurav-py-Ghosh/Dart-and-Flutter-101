import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w13.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('1 FastCounter does not rebuild its child', (tester) async {
    var builds = 0;
    await tester.pumpWidget(
      wrap(FastCounter(child: Probe(onBuild: () => builds++))),
    );
    expect(builds, 1);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('Count: 2'), findsOneWidget);
    expect(builds, 1, reason: 'The child rebuilt when you tapped.');
  });

  test('2 sumJsonInBackground', () async {
    expect(await sumJsonInBackground('[1,2,3]'), 6);
  });

  testWidgets('3 HugeList', (tester) async {
    await tester.pumpWidget(wrap(const HugeList(count: 100000)));
    expect(find.text('Row 0'), findsOneWidget);
    expect(find.text('Row 99999'), findsNothing);
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.itemExtent, 56);
  });
}
