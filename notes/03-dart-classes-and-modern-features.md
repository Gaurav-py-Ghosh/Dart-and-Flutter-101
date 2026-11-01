[Guide home](../README.md) · Back: [02 Dart Basics](02-dart-basics.md) · Next: [04 Dart Async](04-dart-async.md)

# Dart Classes and Modern Features

**Why this matters:** in Flutter, **every widget is a class**. And "What's a mixin?" and "`extends` vs `implements` vs `with`" are among the most common Dart questions.

**See it working:** `dart run bin/d02_oop.dart`

---

# Part 1: Learn

## 1. Classes and objects

A **class** is a blueprint. An **object** is one thing built from that blueprint. "Car" is the class, and your red car is an object.

```dart
class Dog {
  // Fields: what a dog HAS
  String name;
  int age;

  // Constructor: how you BUILD a dog
  Dog(this.name, this.age);

  // Method: what a dog DOES
  String bark() => '$name says woof';
}

void main() {
  final rex = Dog('Rex', 3);  // build an object
  print(rex.bark());          // Rex says woof
  print(rex.age);             // 3
}
```

`this` means "this particular object". `this.name` in a constructor means "put this input straight into the `name` field".

## 2. Constructors: the different ways to build

| Constructor | What it's for | Example |
|---|---|---|
| **Normal** | Build an object | `const User({required this.name, required this.age});` |
| **Named** | A second way to build, with a clear name | `User.guest() : name = 'Guest', age = 0;` |
| **Factory** | Run logic first, and maybe return an existing object | `factory User.fromJson(Map<String, dynamic> json) {...}` |
| **Const** | Allow compile-time objects, when all fields are `final` | `const User(...)` |
| **Primary** (new) | Fields and constructor in one line | `class Point(final int x, final int y);` |

**Named** constructors give extra ways to build. Inside the `: name = 'Guest'` part, called the **initializer list**, you set fields before the object exists:

```dart
User.guest() : name = 'Guest', age = 0;
```

**Factory** constructors can run code first, and don't have to create a new object. They're most often used for JSON:

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(name: json['name'] as String, age: json['age'] as int);
}
```

**Primary constructors** became stable in Dart 3.13. You may not see them much in older code, but they're a good thing to mention.

## 3. Private fields, getters and setters

In Dart, a name starting with `_` is **private to its file**. Nothing outside the file can touch it. It's how you protect data, and it's why you see `_count` everywhere in Flutter.

```dart
class BankAccount {
  int _balance = 0;              // nobody outside can change this directly

  int get balance => _balance;   // a getter: read it like a field

  void deposit(int amount) {     // the only way to change it, with a check
    if (amount <= 0) throw ArgumentError('Must be positive');
    _balance += amount;
  }
}
```

A **getter** looks like a field but runs code: `account.balance`. A **setter** does the same for writing: `set name(String value) {...}`.

## 4. Static

`static` belongs to **the class itself**, not to any one object. There's only one copy, shared by all.

```dart
class Counter {
  static int created = 0;   // one shared number
  int value = 0;            // each object has its own

  Counter() {
    created++;
  }
}

Counter();
Counter();
print(Counter.created);     // 2: read it from the class
```

## 5. Immutability and copyWith

Flutter state is usually **immutable**: rather than editing an object, you make a changed copy. This makes changes easy to detect, and stops one part of the app surprising another.

```dart
class User {
  const User({required this.name, required this.age});
  final String name;
  final int age;

  User copyWith({String? name, int? age}) {
    return User(name: name ?? this.name, age: age ?? this.age);
  }
}

final older = asha.copyWith(age: 26); // asha itself isn't touched
```

`name ?? this.name` means "use the new name if one was given, or else keep the old one".

## 6. Equality: == and hashCode

By default, two objects are equal only if they're the **same object in memory**, even when their contents match.

To compare by **content**, override both `==` and `hashCode`:

```dart
@override
bool operator ==(Object other) =>
    other is User && other.name == name && other.age == age;

@override
int get hashCode => Object.hash(name, age);
```

- `@override` means "I'm replacing something I inherited".
- **Why both?** Sets and Maps use `hashCode` to find items. Equal objects must have equal hash codes, or a Set can hold duplicates.
- The `equatable` and `freezed` packages can write this for you.

## 7. Inheritance: extends

`extends` means **"is a kind of"**. A child class gets all its parent's code, and can change parts of it. A class can have **only one** parent.

```dart
class Animal {
  Animal(this.name);
  final String name;
  String speak() => '...';
}

class Cat extends Animal {
  Cat(super.name);          // pass name up to the parent's constructor

  @override
  String speak() => 'Meow'; // replace the parent's version
}
```

## 8. Abstract classes: a promise with no finished code

An **abstract** class can't be built directly. It says what its children **must** provide, and can include shared code.

```dart
abstract class Shape {
  double get area;                                   // no body: children must write it
  String describe() => 'Area is ${area.toStringAsFixed(1)}'; // shared code
}

class Circle extends Shape {
  Circle(this.radius);
  final double radius;

  @override
  double get area => 3.14 * radius * radius;
}
```

This lets your app depend on an **idea** (`TodoRepository`), rather than one specific version. It's the base of good architecture, as you'll see in [11 App Architecture](11-app-architecture.md).

## 9. implements: signing a contract

`implements` takes only the **shape** of a class. You get none of its code, and must write everything yourself. A class can implement **many**.

```dart
class Square implements Shape {
  Square(this.side);
  final double side;

  @override
  double get area => side * side;

  @override
  String describe() => 'Square of side $side'; // must write this too
}
```

In Dart, **every class is also an interface**, so you can `implements` any class. That's how a fake repository stands in for a real one in tests.

## 10. Mixins: adding skills

A **mixin** is a bundle of reusable code you can add to any class, using `with`. It solves a real problem: a class has only one parent, but what if unrelated classes need the same ability?

```dart
mixin Logger {
  void log(String message) => print('[$runtimeType] $message');
}

mixin Retry {
  int get maxRetries => 3;
}

class PaymentService with Logger, Retry {
  void pay() => log('Paying, will retry up to $maxRetries times');
}
```

You'll use this in Flutter for animations: `with SingleTickerProviderStateMixin`.

If two mixins have the same method, **the last one wins**:

```dart
class Both with A, B {}
Both().who(); // 'B'
```

A mixin can demand a certain parent, using `on`: `mixin Walker on Animal {...}`.

## 11. The big comparison

| Keyword | Like | What you get | How many |
|---|---|---|---|
| `extends` | Inheriting from a parent | The parent's code | One only |
| `implements` | Signing a contract | Only the promise, so you write all the code | Many |
| `with` | Adding skills | Reusable code from a mixin | Many |

## 12. Extensions

Add methods to a class **you don't own**:

```dart
extension StringTools on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

'flutter'.capitalized; // Flutter
```

## 13. Enums

A fixed list of options. Enums can hold data and methods:

```dart
enum OrderStatus {
  placed('Order placed'),
  shipped('On the way'),
  delivered('Delivered');

  const OrderStatus(this.label);
  final String label;

  bool get isFinished => this == OrderStatus.delivered;
}

OrderStatus.shipped.label;      // On the way
OrderStatus.values;             // all the options
OrderStatus.shipped.name;       // 'shipped'
```

**Dot shorthand:** if Dart already knows the type, you can skip its name:

```dart
OrderStatus status = .delivered; // same as OrderStatus.delivered
```

## 14. Generics

`<T>` means **"any type, but stay consistent"**. It's why a `List<String>` only holds strings. You catch mistakes while coding, without writing a separate class for each type.

```dart
class Box<T> {
  Box(this.value);
  final T value;
}

final a = Box<int>(5);       // a.value is an int
final b = Box('hello');      // Dart works out it's a Box<String>

T firstOf<T>(List<T> items) => items.first;  // generic function
```

## 15. Sealed classes and switch

A **sealed** class is a **closed list of possibilities**. If you forget a case in a `switch`, the code **won't compile**. That's perfect for screen states:

```dart
sealed class Result<T> { const Result(); }

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final String error;
}

class Loading<T> extends Result<T> { const Loading(); }

String render(Result<String> result) {
  return switch (result) {
    Loading() => 'Spinner',
    Success(data: final text) => 'Show: $text',
    Failure(error: final message) => 'Error: $message',
  };
}
```

`Success(data: final text)` means "if it's a `Success`, take its `data`, and call it `text`". You can shorten it to `Success(:final data)`.

## 16. Records and patterns

A **record** returns several values without writing a class:

```dart
(String, int) nameAndAge() => ('Asha', 25);
final (name, age) = nameAndAge();

({double lat, double lng}) location() => (lat: 18.5, lng: 73.8); // named
final (:lat, :lng) = location();
```

A **pattern** checks a shape, and pulls out values in one step:

```dart
if (json case {'user': String user, 'roles': [String firstRole, ...]}) {
  print('$user, first role $firstRole');
}

String grade(int marks) => switch (marks) {
  >= 90 => 'A',
  >= 60 && < 90 => 'B',
  _ => 'C',
};
```

## 17. The singleton pattern

A class with exactly one shared object. A private constructor stops anyone else from building one.

```dart
class AppConfig {
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
}

identical(AppConfig(), AppConfig()); // true
```

---

# Part 2: Code along

**Build a small library system.** Type every line in a new file, `bin/my_library.dart`.

**Step 1: A model with an enum.**

```dart
enum Genre { fiction, science, history }

class Book {
  const Book({required this.title, required this.genre, this.isLent = false});

  final String title;
  final Genre genre;
  final bool isLent;

  Book copyWith({bool? isLent}) =>
      Book(title: title, genre: genre, isLent: isLent ?? this.isLent);

  @override
  String toString() => '$title (${genre.name})${isLent ? ', lent' : ''}';
}
```

`toString` controls what `print` shows.

**Step 2: Inheritance.** Students and teachers are both members, with different limits:

```dart
abstract class Member {
  Member(this.name);
  final String name;

  int get maxBooks;
  String describe() => '$name can borrow $maxBooks books';
}

class Student extends Member {
  Student(super.name);

  @override
  int get maxBooks => 2;
}

class Teacher extends Member {
  Teacher(super.name);

  @override
  int get maxBooks => 5;
}
```

**Step 3: A mixin and a sealed result.**

```dart
mixin Logger {
  final List<String> history = [];

  void log(String message) => history.add(message);
}

sealed class LendResult {
  const LendResult();
}

class Lent extends LendResult {
  const Lent(this.book);
  final Book book;
}

class NotFound extends LendResult {
  const NotFound();
}

class LimitReached extends LendResult {
  const LimitReached(this.max);
  final int max;
}
```

**Step 4: The library, using all of the above.**

```dart
class Library with Logger {
  Library(this._books);

  List<Book> _books;
  final Map<String, int> _borrowed = {};

  List<Book> get books => _books;

  LendResult lend(String title, Member member) {
    final count = _borrowed[member.name] ?? 0;
    if (count >= member.maxBooks) return LimitReached(member.maxBooks);

    final matches = _books.where((b) => b.title == title && !b.isLent);
    if (matches.isEmpty) return const NotFound();

    final book = matches.first.copyWith(isLent: true);
    _books = [
      for (final b in _books)
        if (b.title == title) book else b,
    ];
    _borrowed[member.name] = count + 1;
    log('${member.name} borrowed $title');
    return Lent(book);
  }
}
```

Look at how it updates a book: it doesn't edit the old list. It **builds a new list**, with one book swapped. You'll write this exact pattern in Flutter.

**Step 5: An extension, a switch, and `main`.**

```dart
extension Shout on String {
  String get shout => '${toUpperCase()}!';
}

String message(LendResult result) => switch (result) {
  Lent(:final book) => 'Enjoy ${book.title}',
  NotFound() => 'Sorry, not available',
  LimitReached(:final max) => 'Limit of $max reached',
};

void main() {
  final library = Library(const [
    Book(title: 'Dune', genre: Genre.fiction),
    Book(title: 'Cosmos', genre: Genre.science),
    Book(title: 'Sapiens', genre: Genre.history),
  ]);
  final asha = Student('Asha');

  print(asha.describe());
  print(Teacher('Ravi').describe());
  print(message(library.lend('Dune', asha)));
  print(message(library.lend('Dune', asha)));
  print(message(library.lend('Cosmos', asha)));
  print(message(library.lend('Sapiens', asha)));
  print(library.books);
  print(library.history);
  print('done'.shout);
}
```

Run it using `dart run bin/my_library.dart`.

**You should see exactly this:**

```text
Asha can borrow 2 books
Ravi can borrow 5 books
Enjoy Dune
Sorry, not available
Enjoy Cosmos
Limit of 2 reached
[Dune (fiction), lent, Cosmos (science), lent, Sapiens (history)]
[Asha borrowed Dune, Asha borrowed Cosmos]
DONE!
```

**Now change it yourself:**

- [ ] Add a `Guest` member who can borrow 1 book.
- [ ] Add a `giveBack` method that makes a book available again.
- [ ] Add a new `Overdue` result to the sealed class. Read the compile error, then fix the `switch`.

---

# Part 3: Workbook

**Open:** `lib/workbook/w03.dart`

**Check:** `flutter test workbook_test/w03_test.dart`

- [ ] 1 `BankAccount`: private fields, getters, throwing errors
- [ ] 2 `Book`: `fromJson`, `toJson`, `copyWith`, `==`, `hashCode`
- [ ] 3 `Rectangle`: extending an abstract class
- [ ] 4 `Robot`: a mixin
- [ ] 5 `isTeen`: an extension
- [ ] 6 `TrafficLight`: an enum with a getter
- [ ] 7 `Pair`: generics
- [ ] 8 `paymentMessage`: a sealed class and `switch`
- [ ] 9 `minAndMax`: a record

**Number 2 is the most useful.** You'll write classes like this in every real app.

---

# Part 4: Break it on purpose

Using `bin/d02_oop.dart`, run it after each change:

- [ ] Delete the `Loading() => 'Spinner',` line. It won't compile, because the switch no longer covers every case.
- [ ] Swap the mixins to `class Both with B, A {}`. Now it prints `A`.
- [ ] Delete both the `==` and `hashCode` overrides in `User`. `Same content equals` turns `false`.
- [ ] Remove the `describe()` method from `Square`. It won't compile, because `implements` means writing everything yourself.

---

# Part 5: Test yourself

<details>
<summary><code>extends</code> vs <code>implements</code> vs <code>with</code>?</summary>

`extends` inherits a parent's code, and you can only have one parent. `implements` signs a contract: you can have many, but you write all the code yourself. `with` adds reusable code from mixins, and you can have many.

</details>

<details>
<summary>What is a mixin? Why not just use inheritance?</summary>

It's a reusable bundle of code you can add to any class. Dart allows only one parent class, so mixins let unrelated classes share behaviour. Flutter's `SingleTickerProviderStateMixin` is one you'll use all the time.

</details>

<details>
<summary>What's a factory constructor?</summary>

A constructor that runs logic first, and can return an existing object or a subclass. It's commonly used for `fromJson`, caching and singletons.

</details>

<details>
<summary>What does <code>_</code> at the start of a name do?</summary>

It makes the name private to its file. Dart has no `private` keyword. It's used to protect data, so that changes go through methods that can check them.

</details>

<details>
<summary>Why override <code>hashCode</code> along with <code>==</code>?</summary>

Sets and Maps use `hashCode` to find items. Two equal objects must have the same hash, otherwise a Set could hold duplicates or a Map could fail to find your key.

</details>

<details>
<summary>Abstract class vs mixin?</summary>

An abstract class describes what something *is*, and it's usually extended or implemented. A mixin describes what something *can do*, and it's added using `with`. A class has one parent, but can have many mixins.

</details>

<details>
<summary>What does <code>static</code> mean?</summary>

The member belongs to the class, not to any object, so there's one shared copy. You reach it through the class name.

</details>

<details>
<summary>Why make objects immutable? What does <code>copyWith</code> do?</summary>

Immutable objects can't change after they're made, which avoids surprises from shared data and makes changes easy to detect. `copyWith` makes a new object with some fields changed.

</details>

<details>
<summary>What are generics for?</summary>

They let one class or function work with any type, while staying type-safe. A `List<String>` only holds strings, and mistakes are caught at compile time.

</details>

<details>
<summary>Why use sealed classes?</summary>

They define a fixed set of cases, and the compiler makes sure a `switch` handles all of them. If you add a new state later, the compiler points to every place you need to update.

</details>

<details>
<summary>Record vs class?</summary>

A record is a quick way to group a few values, such as returning two values from a function. Use a class when it needs a clear name, methods, or wide use across the app.

</details>

<details>
<summary>What's an extension method useful for?</summary>

Adding helpers to a class you can't edit, such as `String` or `BuildContext`. An example is `context.colors` as a short way to read the theme.

</details>

<details>
<summary>What's a singleton? What's the downside?</summary>

A class with one shared object, made using a private constructor and a factory. The downside is that it's like a global: it's hard to swap in tests, and it hides dependencies. I'd usually prefer dependency injection.

</details>

# Done when

- [ ] You can explain `extends`, `implements` and `with` without looking
- [ ] You typed the library system, and it printed the right output
- [ ] You can write a data class with `fromJson`, `copyWith` and `==` from memory
- [ ] You can write a sealed class and `switch` from memory
- [ ] At least 7 of 9 workbook tests pass

Next: [04 Dart Async](04-dart-async.md)
