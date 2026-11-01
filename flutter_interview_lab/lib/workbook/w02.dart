// NOTE 02 WORKBOOK. Replace each `throw UnimplementedError()` with your code.
// Check it:  flutter test workbook_test/w02_test.dart
// One only:  flutter test workbook_test/w02_test.dart --plain-name "1 total"
// Answers are in lib/workbook_answers/w02.dart. Try for 5 minutes first.

/// 1. Add up all the numbers using a for loop. total([1, 2, 3]) gives 6.
int total(List<int> numbers) => throw UnimplementedError();

/// 2. greet('Asha') gives 'Hello, Asha!'. greet(null) gives 'Hello, Guest!'.
/// Use ??
String greet(String? name) => throw UnimplementedError();

/// 3. Give the text's length, or 0 if it's null. Use ?. and ??
int lengthOrZero(String? text) => throw UnimplementedError();

/// 4. fullName(first: 'Asha', last: 'Rao') gives 'Asha Rao'.
/// fullName(first: 'Asha') gives 'Asha', with no space at the end.
String fullName({required String first, String last = ''}) =>
    throw UnimplementedError();

/// 5. Keep the even numbers, double them, and return a List.
/// evensDoubled([1, 2, 3, 4]) gives [4, 8]. Use where, map and toList.
List<int> evensDoubled(List<int> numbers) => throw UnimplementedError();

/// 6. Count each letter. countLetters('aab') gives {'a': 2, 'b': 1}.
Map<String, int> countLetters(String text) => throw UnimplementedError();

/// 7. Always ['Home', 'Profile']. Add 'Admin' only if isAdmin is true.
/// Use a collection if.
List<String> buildMenu({required bool isAdmin}) => throw UnimplementedError();

/// 8. OBJECT PRACTICE. Use `is` checks:
/// null gives 'nothing'. 5 gives 'number 6' (add 1 to it).
/// 'hi' gives 'text of length 2'. Anything else gives 'something else'.
String describe(Object? value) => throw UnimplementedError();

/// 9. DYNAMIC PRACTICE. Return value.length.
/// If this value has no length, return -1: catch NoSuchMethodError.
int lengthOfDynamic(dynamic value) => throw UnimplementedError();

/// 10. CLOSURE PRACTICE. Return a function that gives start, then start + 1,
/// and so on, each time you call it.
int Function() makeCounter(int start) => throw UnimplementedError();
