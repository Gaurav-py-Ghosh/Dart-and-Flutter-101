// DART LESSON 2: classes, mixins, generics, sealed classes, patterns
// Run with:  dart run bin/d02_oop.dart

void section(String title) => print('\n=== $title ===');

// 1. A normal class with the three common constructor styles.
class User {
  final String name;
  final int age;

  // Generative constructor. this.name fills the field directly.
  const User({required this.name, required this.age});

  // Named constructor: a second way to build the same thing.
  User.guest() : name = 'Guest', age = 0;

  // Factory constructor: runs logic and may return an existing object.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'] as String, age: json['age'] as int);
  }

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  // copyWith: make a changed copy instead of editing the original.
  User copyWith({String? name, int? age}) {
    return User(name: name ?? this.name, age: age ?? this.age);
  }

  // Compare by content, not by memory address.
  @override
  bool operator ==(Object other) =>
      other is User && other.name == name && other.age == age;

  @override
  int get hashCode => Object.hash(name, age);

  @override
  String toString() => 'User($name, $age)';
}

// 2. Primary constructor (Dart 3.13): fields and constructor in one line.
class Point(final int x, final int y);

// 3. Singleton with a factory: everyone gets the same object.
class AppConfig {
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
}

// 4. Abstract class and interface.
abstract class Shape {
  double get area; // no body: subclasses must supply this
  String describe() => 'Area is ${area.toStringAsFixed(1)}'; // shared code
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double get area => 3.14 * radius * radius;
}

// `implements` takes the shape of a class but none of its code.
class Square implements Shape {
  final double side;
  Square(this.side);

  @override
  double get area => side * side;

  @override
  String describe() => 'Square of side $side';
}

// 5. Mixins: reusable abilities you can add to many classes.
mixin Logger {
  void log(String message) => print('[$runtimeType] $message');
}

mixin Retry {
  int get maxRetries => 3;
}

class PaymentService with Logger, Retry {
  void pay() => log('Paying, will retry up to $maxRetries times');
}

// The last mixin wins when names clash.
mixin A {
  String who() => 'A';
}

mixin B {
  String who() => 'B';
}

class Both with A, B {}

// 6. Extensions: add methods to a class you do not own.
extension StringTools on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

// 7. Enums can have fields and methods.
enum OrderStatus {
  placed('Order placed'),
  shipped('On the way'),
  delivered('Delivered');

  const OrderStatus(this.label);
  final String label;

  bool get isFinished => this == OrderStatus.delivered;
}

// 8. Generics: one piece of code that works for any type, safely.
class Box<T> {
  final T value;
  Box(this.value);
  R open<R>(R Function(T) reader) => reader(value);
}

T firstOf<T>(List<T> items) => items.first;

// 9. Sealed classes: a closed list of possibilities.
// The compiler forces your switch to handle every one.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}

class Loading<T> extends Result<T> {
  const Loading();
}

String render(Result<String> result) {
  // Delete one case below and the analyzer reports an error.
  return switch (result) {
    Loading() => 'Spinner',
    Success(data: final text) => 'Show: $text',
    Failure(error: final message) => 'Error: $message',
  };
}

// 10. Records: return several values without writing a class.
(String, int) nameAndAge() => ('Asha', 25);
({double lat, double lng}) location() => (lat: 18.5, lng: 73.8);

// Static vs instance: static belongs to the class itself.
class Counter {
  static int created = 0;
  int value = 0;
  Counter() {
    created++;
  }
}

void main() {
  section('Classes and constructors');
  const asha = User(name: 'Asha', age: 25);
  final older = asha.copyWith(age: 26);
  final fromJson = User.fromJson({'name': 'Asha', 'age': 25});
  print('$asha -> $older, guest: ${User.guest()}');
  print('Same content equals: ${asha == fromJson}');
  print('Same object: ${identical(asha, fromJson)}');
  print('JSON: ${older.toJson()}');

  final point = Point(2, 3);
  print('Primary constructor point: ${point.x}, ${point.y}');
  print('Singleton: ${identical(AppConfig(), AppConfig())}');

  section('extends vs implements vs with');
  print(Circle(2).describe()); // inherited code
  print(Square(2).describe()); // had to write it itself
  PaymentService().pay();
  print('Last mixin wins: ${Both().who()}');

  section('Extensions, enums, generics');
  print('flutter'.capitalized);
  print('${OrderStatus.shipped.label} ${OrderStatus.shipped.isFinished}');
  print(Box(42).open((value) => 'Value is $value'));
  print(firstOf(['a', 'b']));

  section('Sealed classes and switch');
  print(render(const Loading()));
  print(render(const Success('Data')));
  print(render(const Failure('No internet')));

  section('Records and destructuring');
  final (name, age) = nameAndAge();
  final (:lat, :lng) = location();
  print('$name $age at $lat, $lng');

  section('Patterns');
  final json = {'user': 'Asha', 'roles': ['admin', 'dev']};
  if (json case {'user': String user, 'roles': [String firstRole, ...]}) {
    print('Pattern matched $user, first role $firstRole');
  }

  String grade(int marks) => switch (marks) {
    >= 90 => 'A',
    >= 60 && < 90 => 'B',
    _ => 'C',
  };
  print('${grade(95)} ${grade(70)} ${grade(10)}');

  section('Static');
  Counter();
  Counter();
  print('Counters created: ${Counter.created}');

  section('Dot shorthand');
  OrderStatus status = .delivered; // short for OrderStatus.delivered
  print(status.label);
}
