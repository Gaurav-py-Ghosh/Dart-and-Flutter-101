// Run with:  flutter test challenge_test
// All of these fail until you solve lib/challenges/challenges.dart.
// To check the answers instead, change the import below to:
//   package:flutter_interview_lab/solutions/solutions.dart

import 'package:flutter_interview_lab/challenges/challenges.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1 isPalindrome', () {
    expect(isPalindrome('A man, a plan, a canal: Panama'), isTrue);
    expect(isPalindrome('flutter'), isFalse);
    expect(isPalindrome(''), isTrue);
  });

  test('2 wordCount', () {
    expect(wordCount('a b A'), {'a': 2, 'b': 1});
    expect(wordCount(''), <String, int>{});
  });

  test('3 uniqueInOrder', () {
    expect(uniqueInOrder([3, 1, 3, 2, 1]), [3, 1, 2]);
  });

  test('4 twoSum', () {
    expect(twoSum([2, 7, 11, 15], 9), (0, 1));
    expect(twoSum([1, 2], 9), isNull);
  });

  test('5 flatten', () {
    expect(flatten([1, [2, [3, [4]]], 5]), [1, 2, 3, 4, 5]);
  });

  test('6 groupBy', () {
    expect(
      groupBy(['apple', 'avocado', 'mango'], (String fruit) => fruit[0]),
      {'a': ['apple', 'avocado'], 'm': ['mango']},
    );
  });

  test('7 retry succeeds on a later attempt', () async {
    var calls = 0;
    final result = await retry(() async {
      calls++;
      if (calls < 3) throw Exception('fail');
      return 'ok';
    });
    expect(result, 'ok');
    expect(calls, 3);
  });

  test('7 retry gives up and rethrows', () async {
    var calls = 0;
    await expectLater(
      retry<void>(() async {
        calls++;
        throw StateError('always');
      }, maxAttempts: 2),
      throwsStateError,
    );
    expect(calls, 2);
  });

  test('8 Debouncer runs only the last call', () async {
    final debouncer = Debouncer(const Duration(milliseconds: 30));
    final ran = <int>[];
    debouncer(() => ran.add(1));
    debouncer(() => ran.add(2));
    debouncer(() => ran.add(3));
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(ran, [3]);
    debouncer.dispose();
  });

  test('9 Stack', () {
    final stack = Stack<int>();
    expect(stack.isEmpty, isTrue);
    expect(stack.pop(), isNull);
    stack.push(1);
    stack.push(2);
    expect(stack.peek(), 2);
    expect(stack.pop(), 2);
    expect(stack.pop(), 1);
    expect(stack.isEmpty, isTrue);
  });

  test('10 LruCache drops the least recently used item', () {
    final cache = LruCache<String, int>(2);
    cache.put('a', 1);
    cache.put('b', 2);
    expect(cache.get('a'), 1); // a is now the newest
    cache.put('c', 3); // b is the oldest, so b goes
    expect(cache.get('b'), isNull);
    expect(cache.get('a'), 1);
    expect(cache.get('c'), 3);
  });
}
