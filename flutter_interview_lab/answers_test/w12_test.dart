// ANSWERS for note 12. Run:  flutter test answers_test/w12_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w12_target.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakePriceApi implements PriceApi {
  @override
  Future<int> priceOf(String item) async => 10;
}

class MockPriceApi extends Mock implements PriceApi {}

void main() {
  test('1 add puts an item in the list', () {
    final list = ShoppingList();
    list.add('Tea');
    expect(list.items, ['Tea']);
  });

  test('2 add ignores blanks and duplicates', () {
    final list = ShoppingList();
    list.add('  ');
    list.add('Tea');
    list.add('Tea');
    expect(list.items, ['Tea']);
  });

  test('3 add notifies listeners once for each real change', () {
    final list = ShoppingList();
    var calls = 0;
    list.addListener(() => calls++);
    list.add('Tea');
    list.add('Tea');
    expect(calls, 1);
  });

  test('4 total adds up the prices, using a fake', () async {
    final checkout = Checkout(FakePriceApi());
    expect(await checkout.total(['Tea', 'Milk']), 20);
  });

  test('5 total asks the API once for each item, using a mock', () async {
    final api = MockPriceApi();
    when(() => api.priceOf('Tea')).thenAnswer((_) async => 5);
    expect(await Checkout(api).total(['Tea']), 5);
    verify(() => api.priceOf('Tea')).called(1);
  });

  testWidgets('6 GreetingScreen greets by name', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: GreetingScreen())),
    );
    await tester.enterText(find.byType(TextField), 'Asha');
    await tester.tap(find.text('Greet'));
    await tester.pump();
    expect(find.text('Hello Asha'), findsOneWidget);
  });
}
