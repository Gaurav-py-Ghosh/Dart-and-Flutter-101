// ANSWERS for note 03. Try lib/workbook/w03.dart first.

class BankAccount {
  BankAccount(this.owner, [this._balance = 0]);
  final String owner;
  int _balance;

  int get balance => _balance;

  void deposit(int amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    _balance += amount;
  }

  void withdraw(int amount) {
    if (amount > _balance) throw StateError('Not enough money');
    _balance -= amount;
  }
}

class Book {
  const Book({required this.title, required this.pages});

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(title: json['title'] as String, pages: json['pages'] as int);

  final String title;
  final int pages;

  Book copyWith({String? title, int? pages}) =>
      Book(title: title ?? this.title, pages: pages ?? this.pages);

  Map<String, dynamic> toJson() => {'title': title, 'pages': pages};

  @override
  bool operator ==(Object other) =>
      other is Book && other.title == title && other.pages == pages;

  @override
  int get hashCode => Object.hash(title, pages);
}

abstract class Shape {
  double get area;
  String describe() => 'Area: ${area.toStringAsFixed(1)}';
}

class Rectangle extends Shape {
  Rectangle(this.width, this.height);
  final double width;
  final double height;

  @override
  double get area => width * height;
}

mixin Greeter {
  String get name;
  String greet() => 'Hi, I am $name';
}

class Robot with Greeter {
  @override
  String get name => 'Robo';
}

extension NumberTools on int {
  bool get isTeen => this >= 13 && this <= 19;
}

enum TrafficLight {
  red,
  green,
  yellow;

  TrafficLight get next => switch (this) {
    TrafficLight.red => TrafficLight.green,
    TrafficLight.green => TrafficLight.yellow,
    TrafficLight.yellow => TrafficLight.red,
  };
}

class Pair<T> {
  const Pair(this.first, this.second);
  final T first;
  final T second;

  Pair<T> swapped() => Pair(second, first);
}

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

String paymentMessage(PaymentResult result) => switch (result) {
  PaymentSuccess(:final amount) => 'Paid $amount',
  PaymentFailed(:final reason) => 'Failed: $reason',
  PaymentPending() => 'Please wait',
};

(int, int) minAndMax(List<int> numbers) {
  var smallest = numbers.first;
  var largest = numbers.first;
  for (final number in numbers) {
    if (number < smallest) smallest = number;
    if (number > largest) largest = number;
  }
  return (smallest, largest);
}
