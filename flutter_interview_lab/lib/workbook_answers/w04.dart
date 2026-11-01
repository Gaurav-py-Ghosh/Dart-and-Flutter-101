// ANSWERS for note 04. Try lib/workbook/w04.dart first.

import 'dart:async';
import 'dart:isolate';

Future<int> addLater(int a, int b) async {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  return a + b;
}

Future<String> fetchOrFallback(Future<String> Function() fetch) async {
  try {
    return await fetch();
  } catch (_) {
    return 'fallback';
  }
}

Future<int> totalLength(
  Future<String> Function() first,
  Future<String> Function() second,
) async {
  final results = await Future.wait([first(), second()]);
  return results[0].length + results[1].length;
}

Future<String> withinOneSecond(Future<String> job) async {
  try {
    return await job.timeout(const Duration(seconds: 1));
  } on TimeoutException {
    return 'too slow';
  }
}

Stream<int> countDown(int from) async* {
  for (var i = from; i >= 0; i--) {
    yield i;
  }
}

Future<int> sumStream(Stream<int> numbers) async {
  var sum = 0;
  await for (final number in numbers) {
    sum += number;
  }
  return sum;
}

Stream<String> onlyLong(Stream<String> words) =>
    words.where((word) => word.length > 3).map((word) => word.toUpperCase());

int countPrimes(int upTo) {
  var count = 0;
  for (var n = 2; n <= upTo; n++) {
    var isPrime = true;
    for (var d = 2; d * d <= n; d++) {
      if (n % d == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) count++;
  }
  return count;
}

Future<int> countPrimesInBackground(int upTo) =>
    Isolate.run(() => countPrimes(upTo));
