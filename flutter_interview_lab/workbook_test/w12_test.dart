// NOTE 12 WORKBOOK. This time YOU write the tests.
// The code being tested is in lib/workbook/w12_target.dart.
// Replace each fail(...) line with real test code.
// Check it:  flutter test workbook_test/w12_test.dart
// Answers are in answers_test/w12_test.dart. Try for 5 minutes first.

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w12_target.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 4. Write a fake PriceApi here: every item costs 10.

// 5. Write a mock PriceApi here, using mocktail.

void main() {
  test('1 add puts an item in the list', () {
    fail('Write this test. Arrange, act, assert.');
  });

  test('2 add ignores blanks and duplicates', () {
    fail('Write this test. Add "  ", then "Tea" twice. Expect just ["Tea"].');
  });

  test('3 add notifies listeners once for each real change', () {
    fail('Write this test. Count calls with addListener.');
  });

  test('4 total adds up the prices, using a fake', () async {
    fail('Write this test. Give Checkout your fake. Expect 20 for 2 items.');
  });

  test('5 total asks the API once for each item, using a mock', () async {
    fail('Write this test. Use when(...).thenAnswer(...) and verify(...).');
  });

  testWidgets('6 GreetingScreen greets by name', (tester) async {
    fail(
      'Write this test. Wrap it in MaterialApp and Scaffold. Enter text, tap '
      'Greet, pump, and check the message.',
    );
  });
}
