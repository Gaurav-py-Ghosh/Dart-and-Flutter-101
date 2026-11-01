// NOTE 03 WORKBOOK. Replace each `throw UnimplementedError()` with your code.
// Check it:  flutter test workbook_test/w03_test.dart
// Answers are in lib/workbook_answers/w03.dart. Try for 5 minutes first.

/// 1. PRIVATE FIELDS. Keep _balance private, and read it with the balance getter.
/// deposit adds money, and throws ArgumentError if amount <= 0.
/// withdraw removes money, and throws StateError if there isn't enough.
class BankAccount {
  BankAccount(this.owner, [this._balance = 0]);
  final String owner;
  // ignore: prefer_final_fields, unused_field
  int _balance;

  int get balance => throw UnimplementedError();
  void deposit(int amount) => throw UnimplementedError();
  void withdraw(int amount) => throw UnimplementedError();
}

/// 2. A DATA CLASS. Finish fromJson, copyWith and toJson.
/// Then add == and hashCode, so two Books with equal fields are equal.
class Book {
  const Book({required this.title, required this.pages});

  factory Book.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  final String title;
  final int pages;

  Book copyWith({String? title, int? pages}) => throw UnimplementedError();
  Map<String, dynamic> toJson() => throw UnimplementedError();

  // Add operator == and hashCode here.
}

/// 3. INHERITANCE. Do not change Shape. Finish area in Rectangle.
abstract class Shape {
  double get area;
  String describe() => 'Area: ${area.toStringAsFixed(1)}';
}

class Rectangle extends Shape {
  Rectangle(this.width, this.height);
  final double width;
  final double height;

  @override
  double get area => throw UnimplementedError();
}

/// 4. MIXIN. greet returns 'Hi, I am <name>'.
/// Robot uses the mixin, and its name is 'Robo'.
mixin Greeter {
  String get name;
  String greet() => throw UnimplementedError();
}

class Robot with Greeter {
  @override
  String get name => throw UnimplementedError();
}

/// 5. EXTENSION. 13 up to and including 19 is a teen.
extension NumberTools on int {
  bool get isTeen => throw UnimplementedError();
}

/// 6. ENUM. next goes red to green, green to yellow, and yellow to red.
enum TrafficLight {
  red,
  green,
  yellow;

  TrafficLight get next => throw UnimplementedError();
}

/// 7. GENERICS. swapped returns a new Pair with the values the other way round.
class Pair<T> {
  const Pair(this.first, this.second);
  final T first;
  final T second;

  Pair<T> swapped() => throw UnimplementedError();
}

/// 8. SEALED CLASS AND SWITCH. These are finished. Write paymentMessage:
/// PaymentSuccess(50) gives 'Paid 50'. PaymentFailed('No funds') gives
/// 'Failed: No funds'. PaymentPending() gives 'Please wait'.
sealed class PaymentResult {
  const PaymentResult();
}

class PaymentSuccess extends PaymentResult {
  const PaymentSuccess(this.amount);
  final int amount;
}

class PaymentFailed extends PaymentResult {
  const PaymentFailed(this.reason);
  final String reason;
}

class PaymentPending extends PaymentResult {
  const PaymentPending();
}

String paymentMessage(PaymentResult result) => throw UnimplementedError();

/// 9. RECORD. Return the smallest and the largest. minAndMax([3, 1, 2]) gives
/// (1, 3). Write the loop yourself.
(int, int) minAndMax(List<int> numbers) => throw UnimplementedError();
