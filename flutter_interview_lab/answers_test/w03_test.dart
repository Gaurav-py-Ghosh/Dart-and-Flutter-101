import 'package:flutter_interview_lab/workbook_answers/w03.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1 BankAccount', () {
    final account = BankAccount('Asha', 100);
    account.deposit(50);
    expect(account.balance, 150);
    account.withdraw(100);
    expect(account.balance, 50);
    expect(() => account.deposit(0), throwsArgumentError);
    expect(() => account.withdraw(999), throwsStateError);
    expect(account.balance, 50);
  });
  test('2 Book', () {
    final book = Book.fromJson({'title': 'Dart', 'pages': 200});
    expect(book.title, 'Dart');
    expect(book.toJson(), {'title': 'Dart', 'pages': 200});
    final longer = book.copyWith(pages: 300);
    expect(longer.pages, 300);
    expect(longer.title, 'Dart');
    expect(book.pages, 200);
    expect(book == const Book(title: 'Dart', pages: 200), isTrue);
    expect({book, const Book(title: 'Dart', pages: 200)}.length, 1);
  });
  test('3 Rectangle', () {
    expect(Rectangle(2, 3).area, 6);
    expect(Rectangle(2, 3).describe(), 'Area: 6.0');
  });
  test('4 Robot', () => expect(Robot().greet(), 'Hi, I am Robo'));
  test('5 isTeen', () {
    expect(13.isTeen, isTrue);
    expect(19.isTeen, isTrue);
    expect(12.isTeen, isFalse);
    expect(20.isTeen, isFalse);
  });
  test('6 TrafficLight', () {
    expect(TrafficLight.red.next, TrafficLight.green);
    expect(TrafficLight.green.next, TrafficLight.yellow);
    expect(TrafficLight.yellow.next, TrafficLight.red);
  });
  test('7 Pair', () {
    final swapped = const Pair('a', 'b').swapped();
    expect(swapped.first, 'b');
    expect(swapped.second, 'a');
  });
  test('8 paymentMessage', () {
    expect(paymentMessage(const PaymentSuccess(50)), 'Paid 50');
    expect(paymentMessage(const PaymentFailed('No funds')), 'Failed: No funds');
    expect(paymentMessage(const PaymentPending()), 'Please wait');
  });
  test('9 minAndMax', () {
    expect(minAndMax([3, 1, 2]), (1, 3));
    expect(minAndMax([5]), (5, 5));
  });
}
