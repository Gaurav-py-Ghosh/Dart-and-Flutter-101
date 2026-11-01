[Guide home](../README.md) · Back: [01 Start Here](01-start-here.md) · Next: [03 Dart Classes and Modern Features](03-dart-classes-and-modern-features.md)

# Dart Basics

**Why this matters:** every Flutter app is written in Dart. Interviewers often start here, because weak Dart shows up quickly in live coding.

**How this note works:**

1. **Learn:** each idea comes with a small example.
2. **Code along:** you type a small program from an empty file.
3. **Workbook:** you solve 10 problems, and tests tell you whether you got them right.

You can run any example by pasting it into `bin/d01_basics.dart`, or a new file of your own.

---

# Part 1: Learn

## 1. What is a Dart program?

```dart
void main() {
  print('Hello'); // this shows text in the terminal
}
```

Line by line:

| Piece | Meaning |
|---|---|
| `void` | This function gives nothing back |
| `main` | The name Dart looks for. **Every program starts here** |
| `()` | The inputs. There are none here |
| `{ }` | The code that belongs to this function |
| `print('Hello')` | Calls a built-in function that shows text |
| `;` | Ends a statement. Dart needs these |
| `// ...` | A comment. Dart ignores it. It's a note for humans |

## 2. Types: what kind of value is this?

Every value in Dart has a **type**. The type decides what you can do with it. You can add two numbers, and you can ask a string for its length, but you can't ask a number for its length.

| Type | Holds | Example |
|---|---|---|
| `int` | Whole numbers | `int age = 25;` |
| `double` | Decimal numbers | `double price = 49.5;` |
| `num` | Either of those | `num value = 3;` |
| `String` | Text | `String name = 'Asha';` |
| `bool` | `true` or `false` | `bool isAdmin = true;` |
| `List` | An ordered group | `List<int> marks = [90, 80];` |
| `Set` | Unique items | `Set<String> tags = {'new', 'sale'};` |
| `Map` | Key and value pairs | `Map<String, int> prices = {'tea': 20};` |

The `<int>` means "a list **of ints**". You'll learn more about this in [03 Dart Classes and Modern Features](03-dart-classes-and-modern-features.md).

**Changing a type:**

```dart
int.parse('42');        // text into a number: 42
double.parse('4.5');    // text into a decimal: 4.5
42.toString();          // number into text: '42'
3.7.toInt();            // decimal into whole number: 3 (it cuts off, it doesn't round)
int.tryParse('hello');  // gives null rather than crashing
```

## 3. var, final and const

These control whether a variable **can change**.

Think of a whiteboard, a printed page and a carved stone:

| Keyword | Like | Can it change? | When is the value decided? |
|---|---|---|---|
| `var` | Whiteboard | Yes, but the type stays the same | Any time |
| `final` | Printed page | No, once it's set | While the app runs |
| `const` | Carved stone | Never | Before the app runs (compile time) |

```dart
var score = 10;
score = 20;     // fine

final startedAt = DateTime.now();  // fine: known once the app runs
const maxLives = 3;                // fine: known in advance
```

`const now = DateTime.now();` **won't compile**, because nobody knows the time before the app runs.

**The trap everyone gets asked about:** `final` protects the *variable*, not the *contents*.

```dart
final finalList = [1, 2];
finalList.add(3);      // allowed: same list, with one more item
// finalList = [9];    // error: can't point at a different list

const constList = [1, 2];
// constList.add(3);   // crashes: a const list is completely frozen
```

**Why Flutter cares:** identical `const` values are **one shared object** in memory. Flutter can skip rebuilding a `const` widget, as it knows it's the same one.

```dart
print(identical(const [1], const [1])); // true: one object
print(identical([1], [1]));             // false: two objects
```

## 4. dynamic, Object and var: the differences

> [!IMPORTANT]
> **A favourite interview question**
>
> Interviewers love this question, and it trips up many people, because all three seem to "hold anything".

First, know these two moments, as the whole difference depends on them:

- **Compile time:** before the app runs. Dart reads your code, and reports errors in VS Code as red lines. Finding a mistake here is **free**.
- **Runtime:** while the app runs. A mistake here is a **crash in front of a user**.

### var: "work out the type, and then lock it"

`var` isn't a type. It just means "Dart, you work out the type". After that, the type is fixed.

```dart
var city = 'Pune';  // Dart decides: city is a String
city = 'Delhi';     // fine
city = 5;           // compile error: an int can't go in a String variable
```

The exact error is `A value of type 'int' can't be assigned to a variable of type 'String'`.

### dynamic: "turn off the safety checks"

`dynamic` tells Dart: **don't check this. I'll be responsible.** The variable can hold anything, and can change type. You can call anything on it, and Dart won't complain until the app is running.

```dart
dynamic anything = 'hello';
print(anything.length);   // 5
anything = 42;            // fine: it can change type
print(anything.isEven);   // true
print(anything.length);   // no red line, but it CRASHES when it runs
```

That last line throws a `NoSuchMethodError`, because a number has no length. **The compiler couldn't help you.** That's the danger.

### Object: "it can be anything, but prove it before you use it"

Every value in Dart is an `Object`. So an `Object?` variable can also hold anything, **but the safety checks stay on**. Dart only lets you use what it can guarantee exists.

```dart
Object? box = 'hello';
print(box.length);   // compile error: Dart can't be sure this is a String
```

So you **check the type first**, using `is`. Once you've checked, Dart remembers. This is called **type promotion**.

```dart
if (box is String) {
  print(box.length);  // fine: in here, Dart knows it's a String
}
```

- `Object` can hold anything except `null`.
- `Object?` can hold anything, including `null`.

### Side by side

| | `var` | `dynamic` | `Object?` |
|---|---|---|---|
| Is it a real type? | No, it's a shortcut | Yes | Yes |
| Can it hold anything? | Only its first type | Yes | Yes |
| Can it change type later? | No | Yes | Yes |
| Can you call any method on it? | Only that type's | **Yes, unchecked** | No, check first |
| Mistakes appear | Compile time | **Runtime** | Compile time |
| Safe? | Yes | **No** | Yes |

### One trap with var

If you write `var` with **no starting value**, Dart has nothing to work from, so the variable becomes `dynamic`:

```dart
var unset;     // this is dynamic!
unset = 1;
unset = 'a';   // no error
```

Fix it by giving it a type: `String? unset;`.

### When do you see dynamic?

Mostly with **JSON**. `jsonDecode` gives you `Map<String, dynamic>`, because a server's reply could hold anything. The good habit is to convert it into your own class straight away, as you'll do in [10 Networking and Storage](10-networking-and-storage.md).

```dart
final name = json['name'] as String; // `as` says: treat this as a String
```

`as` checks at runtime, and crashes if you're wrong. `is` only asks the question, so it's safe.

## 5. Null safety

`null` means "there's no value here". In many older languages, using a null value crashes the app. In Dart, **a variable can't be null unless you say so**, and the compiler checks this before the app runs.

```dart
String name = 'Asha';  // can never be null
String? nickname;      // the ? means it might be null
```

| Symbol | Meaning | Example | Result when null |
|---|---|---|---|
| `?` | This may be null | `String? nickname` | |
| `?.` | Use it only if it isn't null | `nickname?.length` | `null`, no crash |
| `??` | Use this if it's null | `nickname ?? 'none'` | `'none'` |
| `??=` | Assign only if it's null | `nickname ??= 'Ash'` | Now it's `'Ash'` |
| `!` | "Trust me, it's not null" | `nickname!.length` | **Crash** |
| `late` | "I'll set this before I use it" | `late String token;` | Crash if read too early |

**Promotion works here too.** After you check for null, Dart knows:

```dart
String? nickname = findNickname();
if (nickname != null) {
  print(nickname.length); // no ? or ! needed
}
```

**Good habit:** avoid `!`. It's the usual cause of `Null check operator used on a null value`.

## 6. Operators

| Kind | Operators | Note |
|---|---|---|
| Maths | `+ - * /` | `/` always gives a double: `7 / 2` is `3.5` |
| Whole division | `~/` | `7 ~/ 2` is `3` |
| Remainder | `%` | `7 % 2` is `1`. Use it for even or odd checks |
| Compare | `== != > < >= <=` | Gives a bool |
| Logic | `&& \|\| !` | And, or, not |
| Update | `+= ++ --` | `count++` adds 1 |
| Short if | `a ? b : c` | `isOld ? 'Old' : 'New'` |

## 7. Strings

```dart
final price = 49;
print('Price: $price');                 // put a variable in the text
print('With tax: ${price * 1.18}');     // use ${} for an expression
print('  trim me '.trim().toUpperCase()); // TRIM ME
print('a,b,c'.split(','));              // [a, b, c]
print('flutter'.contains('tt'));        // true
```

## 8. Making decisions

```dart
if (share > 500) {
  print('Expensive');
} else if (share > 200) {
  print('Fair');
} else {
  print('Cheap');
}
```

`switch` compares against several values:

```dart
final label = switch (status) {
  'new' => 'Just arrived',
  'old' => 'Clearance',
  _ => 'Unknown', // _ means "anything else"
};
```

## 9. Loops

```dart
for (var i = 0; i < 3; i++) {   // count: 0, 1, 2
  print(i);
}

for (final name in names) {     // each item. Use this one most often
  print(name);
}

while (count > 0) {             // while something's true
  count--;
}
```

`break` leaves the loop. `continue` skips to the next round.

## 10. Lists, sets and maps

| Type | Like | Key point |
|---|---|---|
| `List` | Numbered queue | Ordered, allows duplicates, read with `list[0]` |
| `Set` | Guest list | No duplicates, fast "is it in here?" check |
| `Map` | Dictionary | Look up a value by its key |

```dart
final fruits = ['apple', 'mango'];
fruits.add('kiwi');
fruits.length;           // 3
fruits.contains('kiwi'); // true

final prices = {'apple': 100};
prices['mango'] = 150;   // add or update
prices['kiwi'];          // null: a missing key gives null, not a crash
prices.keys;             // the keys
prices.values;           // the values
prices.entries;          // both together
```

**Build lists with logic inside them.** Flutter code uses this all the time:

```dart
final menu = ['Home', 'Profile', if (isAdmin) 'Admin'];
final doubled = [for (final n in [1, 2, 3]) n * 2];
final both = [...listA, ...listB];   // ... is the "spread": pour a list in
print(['a', ...?extras, ?maybeTag]); // skip these if they're null
```

## 11. map, where, fold

These process a list without you writing a loop.

```dart
final numbers = [1, 2, 3, 4, 5, 6];
numbers.where((n) => n.isEven).toList();    // keep some: [2, 4, 6]
numbers.map((n) => n * n).toList();         // change each: [1, 4, 9...]
numbers.reduce((a, b) => a + b);            // combine: 21
numbers.fold(100, (total, n) => total + n); // combine from a start: 121
numbers.any((n) => n > 5);                  // is any true? true
numbers.every((n) => n > 5);                // are all true? false
```

`(n) => n * n` is a small function with no name. It takes `n`, and gives back `n * n`.

**The trap:** `map` and `where` are **lazy**. They don't run until something reads the result. They return an `Iterable`, which is a list-like sequence that works things out when asked. That's why you usually see `.toList()` at the end.

## 12. Functions

```dart
int add(int a, int b) {        // return type, name, inputs
  return a + b;
}

int multiply(int a, int b) => a * b;  // => is a shortcut for one line
```

**Three ways to take inputs:**

```dart
// Positional: the order matters
int add(int a, int b) => a + b;
add(2, 3);

// Optional positional, in []
String label(String text, [String? suffix]) =>
    suffix == null ? text : '$text $suffix';
label('Done');

// Named, in {}: clear to read, and it's the Flutter style
String welcome({required String name, String greeting = 'Hello'}) =>
    '$greeting, $name!';
welcome(name: 'Asha');
```

- `required` means you must pass it.
- `= 'Hello'` gives a default value.

**A function is a value.** You can store it, or pass it to another function:

```dart
final shout = (String text) => text.toUpperCase();
print(shout('hi'));                       // HI
print(['a', 'b'].map(shout).toList());    // [A, B]
```

**A closure** is a function that remembers variables from where it was made:

```dart
int Function() makeCounter() {
  var count = 0;
  return () => ++count;
}
final counter = makeCounter();
counter(); // 1
counter(); // 2: it still remembers count
```

## 13. Cascades

`..` calls several things on one object, and gives back the object:

```dart
final buffer = StringBuffer()
  ..write('Hello')
  ..write(' World');
```

## 14. Handling errors

```dart
try {
  final age = int.parse('abc');   // this throws
} on FormatException catch (e) {  // catch this exact kind
  print('Not a number: ${e.message}');
} catch (e) {                     // catch anything else
  print('Something else: $e');
} finally {
  print('This always runs');
}

throw Exception('Something went wrong'); // create your own error
```

## 15. How Dart runs, and manages memory

You'll need these for interview questions:

- **Compiling:** Dart turns your code into something a machine can run. See [05 How Flutter Works](05-how-flutter-works.md).
- **Garbage collection:** you never free memory yourself. Dart finds objects nothing uses any more, and removes them. It's built for many short-lived objects, which suits Flutter, as it creates lots of small widgets.
- **Tree shaking:** when building for release, the compiler leaves out code that's never used, which makes the app smaller.

---

# Part 2: Code along

**Build a bill splitter.** Don't paste it. **Type every line**, as your fingers need the practice for a live coding round.

**Step 1.** In VS Code, create a new file called `bin/my_bill.dart`, and add:

```dart
void main() {
  const people = ['Asha', 'Ravi', 'Meera'];
  final prices = {'Pizza': 600.0, 'Tea': 90.0, 'Cake': 310.0};

  var total = 0.0;
  for (final entry in prices.entries) {
    print('${entry.key}: ${entry.value}');
    total += entry.value;
  }
  print('Total: $total');
}
```

Run it using `dart run bin/my_bill.dart`.

- Why is `people` `const`? The names are known in advance, and they never change.
- Why is `total` `var`? It changes each time round the loop.
- Why `0.0`, not `0`? So that Dart makes it a `double`, as the prices are doubles.

**Step 2.** Above `main`, add two functions:

```dart
double splitBill({required double amount, required int people, double tip = 0}) {
  return (amount + tip) / people;
}

String describeBill(double share) {
  if (share > 500) {
    return 'Expensive';
  } else if (share > 200) {
    return 'Fair';
  }
  return 'Cheap';
}
```

**Step 3.** At the end of `main`, add:

```dart
  final share = splitBill(amount: total, people: people.length, tip: 50);
  print('Each pays ${share.toStringAsFixed(2)}, which is ${describeBill(share)}');

  final costly = prices.entries
      .where((entry) => entry.value > 100)
      .map((entry) => entry.key)
      .toList();
  print('Costly items: $costly');

  String? coupon;
  print('Coupon: ${coupon ?? 'none'}, length ${coupon?.length ?? 0}');
  coupon = 'SAVE10';
  print('Coupon: $coupon, length ${coupon.length}');
```

Notice the last line needs no `?`. You just gave `coupon` a value, so Dart promoted it to non-null.

**You should see exactly this:**

```text
Pizza: 600.0
Tea: 90.0
Cake: 310.0
Total: 1000.0
Each pays 350.00, which is Fair
Costly items: [Pizza, Cake]
Coupon: none, length 0
Coupon: SAVE10, length 6
```

**Now change it yourself:**

- [ ] Add a discount of 10% if the total is over 800.
- [ ] Print each person's name with their share, using a `for` loop over `people`.
- [ ] Make `costly` use a `for` inside a list instead of `where` and `map`.

## See dynamic and Object for yourself

Add this function to the same file, and call `typesDemo();` from the start of `main`:

```dart
void typesDemo() {
  dynamic anything = 'hello';
  print(anything.length);
  anything = 42;
  print(anything.isEven);
  try {
    print(anything.length);
  } on NoSuchMethodError {
    print('dynamic crashed at runtime: an int has no length');
  }

  Object? box = 'hello';
  if (box is String) {
    print(box.length);
  }
  box = 42;
  print(box is String);
  print(box.runtimeType);
}
```

You should see `5`, `true`, the crash message, `5`, `false`, `int`.

- [ ] Remove the `if (box is String)` check, and keep the `print`. Read the red line in VS Code. **It's caught before you run anything.**
- [ ] Change `Object? box` to `dynamic box`. The red line disappears. Run it, and think about which is safer.

---

# Part 3: Workbook

**Open:** `lib/workbook/w02.dart`. Replace each `throw UnimplementedError()` with your own code.

To turn a one-line function into a full one, replace everything after the `)`:

```dart
// Before
int total(List<int> numbers) => throw UnimplementedError();

// After
int total(List<int> numbers) {
  // your code
}
```

**Check your work:**

```powershell
flutter test workbook_test/w02_test.dart
```

All 10 fail at first. That's expected. To check just one:

```powershell
flutter test workbook_test/w02_test.dart --plain-name "1 total"
```

**How to read a failed test:**

```text
Expected: <6>
  Actual: <0>
```

Your function returned `0`, but the test wanted `6`.

- [ ] 1 `total`: a loop
- [ ] 2 `greet`: `??`
- [ ] 3 `lengthOrZero`: `?.` and `??`
- [ ] 4 `fullName`: named parameters
- [ ] 5 `evensDoubled`: `where`, `map`, `toList`
- [ ] 6 `countLetters`: building a Map
- [ ] 7 `buildMenu`: a collection `if`
- [ ] 8 `describe`: **Object** and `is`
- [ ] 9 `lengthOfDynamic`: **dynamic** and `NoSuchMethodError`
- [ ] 10 `makeCounter`: a closure

Stuck for over 5 minutes? Compare with `lib/workbook_answers/w02.dart`, understand it, close it, and write it again from memory.

---

# Part 4: Break it on purpose

Using `bin/d01_basics.dart`:

- [ ] Remove the `//` before `constList.add(3)`. It crashes at runtime with `Cannot add to an unmodifiable list`.
- [ ] Change `const maxLives = 3` to `const maxLives = DateTime.now().year`. It won't compile.
- [ ] Change `String? risky;` to `String risky;`. Read the error.
- [ ] Remove `.toList()` from the `even:` line. It prints `(2, 4, 6)` with round brackets, because it's a lazy list-like object (an `Iterable`).

---

# Part 5: Test yourself

Answer out loud, then click to check.

<details>
<summary>What's the difference between <code>final</code> and <code>const</code>?</summary>

Both can only be set once. `final` is set while the app runs, so it can hold something like the current time. `const` must be known before the app runs, and it's frozen all the way down. Identical const values share one object in memory.

</details>

<details>
<summary>What's the difference between <code>var</code>, <code>dynamic</code> and <code>Object?</code></summary>

`var` lets Dart work out the type, and then that type is fixed. `dynamic` turns off type checks, so the variable can hold anything and you can call anything on it, but mistakes only appear at runtime. `Object?` can also hold anything, but the checks stay on, so you must confirm the type using `is` before using it. So I prefer `Object?` to `dynamic` when the type really is unknown.

</details>

<details>
<summary>Why is <code>dynamic</code> risky? Give an example.</summary>

The compiler stops checking. If `value` is a `dynamic` holding `42`, then `value.length` shows no error in the editor, but it throws a `NoSuchMethodError` when it runs. With `Object?`, the same mistake is a compile error.

</details>

<details>
<summary>What does <code>var x;</code> with no value make?</summary>

A `dynamic`, as Dart has nothing to work out the type from. It's better to write the type: `String? x;`.

</details>

<details>
<summary><code>is</code> vs <code>as</code>?</summary>

`is` asks a question, and gives a bool, so it's safe. After it, Dart promotes the variable to that type. `as` forces the type, and crashes at runtime if it's wrong. I prefer `is`, and use `as` where I'm sure, such as reading known JSON fields.

</details>

<details>
<summary>What is sound null safety?</summary>

Types can't be null unless you add `?`. The compiler checks this before the app runs, which prevents a whole class of crashes. "Sound" means Dart can fully trust a non-nullable type, so it can also optimise the code better.

</details>

<details>
<summary>When would you use <code>late</code>?</summary>

When a non-nullable value can't be set where it's declared, but it will definitely be set before use. An example is a controller created in `initState`. It also makes the value lazy. If you read it before it's set, you get a `LateInitializationError`.

</details>

<details>
<summary>Why is <code>!</code> risky?</summary>

It removes the compiler's protection. If the value is null, the app crashes at runtime. Prefer `?.`, `??`, or an `if` check.

</details>

<details>
<summary>List vs Set vs Map?</summary>

A List is ordered and allows duplicates. A Set holds only unique values. A Map stores key and value pairs. Checking whether an item is in a Set or Map is usually much faster than searching a List.

</details>

<details>
<summary>What does "lazy" mean for <code>map</code> and <code>where</code>?</summary>

They don't do the work when you call them. They return an `Iterable` that does the work when you read it, and only for the items you read. Use `.toList()` to run it right away.

</details>

<details>
<summary>Named or positional parameters?</summary>

Named parameters read clearly at the call site, can be in any order, and are the Flutter style. Use `required` if one must be passed. Positional parameters suit small functions where the meaning is obvious.

</details>

<details>
<summary>What is a closure?</summary>

A function that remembers variables from where it was created, even after that outer function has finished. It's what lets callbacks like `onPressed: () => setState(...)` use variables around them.

</details>

<details>
<summary>Compile-time vs runtime error?</summary>

A compile-time error is found before the app runs, like a red line in the editor. A runtime error happens while the app runs, and a user might see it. Dart's type system is there to move as many as possible to compile time.

</details>

<details>
<summary>What is garbage collection?</summary>

Dart automatically frees memory for objects nothing refers to any more. You don't free memory by hand. But you can still leak memory, if something keeps a reference to an object you've finished with, such as a listener that was never removed.

</details>

<details>
<summary>What is tree shaking?</summary>

When building for release, the compiler removes code that's never used, which makes the app smaller.

</details>

# Done when

- [ ] You can explain `final` vs `const` and the list trap, out loud
- [ ] You can name all six null safety symbols
- [ ] You did the four "Break it" steps
- [ ] You can explain `var`, `dynamic` and `Object?`, with an example of each
- [ ] You typed the bill splitter yourself, and it printed the right output
- [ ] At least 8 of 10 workbook tests pass

Next: [03 Dart Classes and Modern Features](03-dart-classes-and-modern-features.md)
