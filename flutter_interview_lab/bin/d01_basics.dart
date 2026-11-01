// DART LESSON 1: the basics
// Run with:  dart run bin/d01_basics.dart
// Change a line, save, run it again. That is the whole method.

void section(String title) => print('\n=== $title ===');

// A normal function with a return type.
int add(int a, int b) {
  return a + b;
}

// Arrow syntax: same thing for one-line functions.
int multiply(int a, int b) => a * b;

// Named parameters live in {}. `required` means you must pass it.
// `greeting` has a default value, so it is optional.
String welcome({required String name, String greeting = 'Hello'}) {
  return '$greeting, $name!';
}

// Positional optional parameters live in [].
String label(String text, [String? suffix]) {
  return suffix == null ? text : '$text $suffix';
}

// A function that takes another function as input.
List<int> applyToAll(List<int> numbers, int Function(int) action) {
  return [for (final n in numbers) action(n)];
}

String? findNickname() => null; // pretend this looked in a database

void main() {
  section('1. var, final, const');
  var score = 10; // can change. The type (int) is worked out and fixed.
  score = 20;
  final startedAt = DateTime.now(); // set once, while the app runs
  const maxLives = 3; // fixed before the app even runs (compile time)
  print('score=$score maxLives=$maxLives startedAt set: ${startedAt.year > 0}');

  // final list: you cannot point at another list, but you CAN change items.
  final finalList = [1, 2];
  finalList.add(3);
  print('final list can still grow: $finalList');

  // const list: frozen completely. Uncomment the next line to see it crash.
  const constList = [1, 2];
  // constList.add(3); // Unsupported operation: Cannot add to an unmodifiable list
  print('const list is frozen: $constList');

  // Two identical const values are the SAME object in memory.
  print('const objects shared: ${identical(const [1], const [1])}'); // true
  print('normal objects shared: ${identical([1], [1])}'); // false

  section('2. Null safety');
  String name = 'Asha'; // can never be null
  String? nickname = findNickname(); // the ? means "might be null"
  print(name.length); // safe
  print(nickname?.length); // ?. gives null instead of crashing
  print(nickname ?? 'no nickname'); // ?? gives a fallback
  nickname ??= 'Ash'; // assign only if it is null right now
  print(nickname);
  print(nickname.length); // Dart now knows it is not null ("promotion")

  // The ! operator says "trust me, this is not null". Wrong = runtime crash.
  String? risky;
  try {
    print(risky!.length);
  } on TypeError catch (e) {
    print('Crash caught from using ! on null: $e');
  }

  section('3. Strings');
  final price = 49;
  print('Price: $price, with tax: ${price * 1.18}');
  print('''
A triple-quoted string
keeps its line breaks.''');
  print('  trim me '.trim().toUpperCase());

  section('4. Lists, sets and maps');
  final fruits = ['apple', 'mango', 'apple'];
  final uniqueFruits = {...fruits}; // Set removes duplicates
  final prices = {'apple': 100, 'mango': 150};
  print('list=$fruits set=$uniqueFruits map=$prices');
  print('missing key gives null: ${prices['kiwi']}');

  // Collection if and for: build lists right inside the brackets.
  const isAdmin = true;
  final menu = ['Home', 'Profile', if (isAdmin) 'Admin'];
  final doubled = [for (final n in [1, 2, 3]) n * 2];
  print('menu=$menu doubled=$doubled');

  // Spread, and null-aware spread and elements.
  List<String>? extras;
  String? maybeTag;
  print(['a', ...?extras, ?maybeTag, 'b']); // [a, b]

  section('5. map, where, reduce, fold');
  final numbers = [1, 2, 3, 4, 5, 6];
  print('even: ${numbers.where((n) => n.isEven).toList()}');
  print('squares: ${numbers.map((n) => n * n).toList()}');
  print('sum: ${numbers.reduce((a, b) => a + b)}');
  print('sum from 100: ${numbers.fold(100, (total, n) => total + n)}');
  print('any > 5: ${numbers.any((n) => n > 5)}');

  // map and where are LAZY: nothing runs until you read the result.
  final lazy = numbers.map((n) {
    print('  working on $n');
    return n * 10;
  });
  print('Nothing printed above yet. Now reading only the first item:');
  print(lazy.first);

  section('6. Functions');
  print(add(2, 3));
  print(multiply(2, 3));
  print(welcome(name: 'Asha'));
  print(welcome(name: 'Ravi', greeting: 'Namaste'));
  print(label('Done'));
  print(label('Done', 'today'));
  print(applyToAll([1, 2, 3], (n) => n + 1));

  // A closure remembers variables from where it was created.
  int Function() makeCounter() {
    var count = 0;
    return () => ++count;
  }

  final counter = makeCounter();
  print('closure: ${counter()}, ${counter()}, ${counter()}');

  section('7. Cascades');
  // .. calls many things on one object, and gives back the object.
  final buffer = StringBuffer()
    ..write('Hello')
    ..write(' ')
    ..write('World');
  print(buffer);

  section('8. Errors');
  try {
    throw const FormatException('Bad input');
  } on FormatException catch (e) {
    print('Caught exactly this type: ${e.message}');
  } catch (e) {
    print('Caught anything else: $e');
  } finally {
    print('finally always runs');
  }
}
