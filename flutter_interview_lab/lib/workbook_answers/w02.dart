// ANSWERS for note 02. Try lib/workbook/w02.dart first.

int total(List<int> numbers) {
  var sum = 0;
  for (final number in numbers) {
    sum += number;
  }
  return sum;
}

String greet(String? name) => 'Hello, ${name ?? 'Guest'}!';

int lengthOrZero(String? text) => text?.length ?? 0;

String fullName({required String first, String last = ''}) =>
    '$first $last'.trim();

List<int> evensDoubled(List<int> numbers) =>
    numbers.where((n) => n.isEven).map((n) => n * 2).toList();

Map<String, int> countLetters(String text) {
  final counts = <String, int>{};
  if (text.isEmpty) return counts;
  for (final letter in text.split('')) {
    counts[letter] = (counts[letter] ?? 0) + 1;
  }
  return counts;
}

List<String> buildMenu({required bool isAdmin}) => [
  'Home',
  'Profile',
  if (isAdmin) 'Admin',
];

String describe(Object? value) {
  if (value == null) return 'nothing';
  if (value is int) return 'number ${value + 1}';
  if (value is String) return 'text of length ${value.length}';
  return 'something else';
}

int lengthOfDynamic(dynamic value) {
  try {
    return value.length as int;
  } on NoSuchMethodError {
    return -1;
  }
}

int Function() makeCounter(int start) {
  var count = start;
  return () => count++;
}
