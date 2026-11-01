import 'package:flutter_interview_lab/workbook/w02.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1 total', () {
    expect(total([1, 2, 3]), 6);
    expect(total([]), 0);
  });
  test('2 greet', () {
    expect(greet('Asha'), 'Hello, Asha!');
    expect(greet(null), 'Hello, Guest!');
  });
  test('3 lengthOrZero', () {
    expect(lengthOrZero('abc'), 3);
    expect(lengthOrZero(null), 0);
  });
  test('4 fullName', () {
    expect(fullName(first: 'Asha', last: 'Rao'), 'Asha Rao');
    expect(fullName(first: 'Asha'), 'Asha');
  });
  test('5 evensDoubled', () {
    expect(evensDoubled([1, 2, 3, 4]), [4, 8]);
    expect(evensDoubled([1]), isA<List<int>>());
  });
  test('6 countLetters', () {
    expect(countLetters('aab'), {'a': 2, 'b': 1});
    expect(countLetters(''), <String, int>{});
  });
  test('7 buildMenu', () {
    expect(buildMenu(isAdmin: false), ['Home', 'Profile']);
    expect(buildMenu(isAdmin: true), ['Home', 'Profile', 'Admin']);
  });
  test('8 describe', () {
    expect(describe(null), 'nothing');
    expect(describe(5), 'number 6');
    expect(describe('hi'), 'text of length 2');
    expect(describe(2.5), 'something else');
  });
  test('9 lengthOfDynamic', () {
    expect(lengthOfDynamic('abc'), 3);
    expect(lengthOfDynamic([1, 2]), 2);
    expect(lengthOfDynamic(42), -1);
  });
  test('10 makeCounter', () {
    final counter = makeCounter(5);
    expect(counter(), 5);
    expect(counter(), 6);
    expect(makeCounter(1)(), 1);
  });
}
