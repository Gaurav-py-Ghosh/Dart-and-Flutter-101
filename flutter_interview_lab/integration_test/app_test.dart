// Runs the real app on a real device, and taps through it.
// Run with:  flutter test integration_test -d windows

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('open the form lab and submit a real email', (tester) async {
    await tester.pumpWidget(const LabApp());
    await tester.tap(find.text('Forms'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'asha@example.com');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome asha@example.com'), findsOneWidget);
  });
}
