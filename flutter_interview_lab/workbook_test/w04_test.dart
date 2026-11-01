import 'package:flutter_interview_lab/workbook/w04.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1 addLater', () async => expect(await addLater(2, 3), 5));
  test('2 fetchOrFallback', () async {
    expect(await fetchOrFallback(() async => 'data'), 'data');
    expect(
      await fetchOrFallback(() async => throw Exception('down')),
      'fallback',
    );
  });
  test('3 totalLength runs together', () async {
    final watch = Stopwatch()..start();
    Future<String> slow(String text) async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return text;
    }

    expect(await totalLength(() => slow('ab'), () => slow('cde')), 5);
    expect(watch.elapsedMilliseconds, lessThan(350));
  });
  test('4 withinOneSecond', () async {
    expect(await withinOneSecond(Future.value('fast')), 'fast');
    expect(
      await withinOneSecond(
        Future.delayed(const Duration(seconds: 2), () => 'late'),
      ),
      'too slow',
    );
  });
  test('5 countDown', () async {
    expect(await countDown(3).toList(), [3, 2, 1, 0]);
  });
  test('6 sumStream', () async {
    expect(await sumStream(Stream.fromIterable([1, 2, 3])), 6);
  });
  test('7 onlyLong', () async {
    final words = Stream.fromIterable(['a', 'flutter', 'dart', 'go']);
    expect(await onlyLong(words).toList(), ['FLUTTER', 'DART']);
  });
  test('8 countPrimesInBackground', () async {
    expect(await countPrimesInBackground(100), 25);
  });
}
