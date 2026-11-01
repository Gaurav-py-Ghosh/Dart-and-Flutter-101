// NOTE 04 WORKBOOK. Replace each `throw UnimplementedError()` with your code.
// Check it:  flutter test workbook_test/w04_test.dart
// Answers are in lib/workbook_answers/w04.dart. Try for 5 minutes first.
//
// You'll need these imports for some answers:
//   import 'dart:async';    (TimeoutException)
//   import 'dart:isolate';  (Isolate.run)

/// 1. Wait 10 milliseconds with Future.delayed, then return a + b.
Future<int> addLater(int a, int b) => throw UnimplementedError();

/// 2. Return what fetch() gives. If it fails, return 'fallback'.
/// Use async, await, try and catch.
Future<String> fetchOrFallback(Future<String> Function() fetch) =>
    throw UnimplementedError();

/// 3. Run both at the same time with Future.wait, and add up the two lengths.
Future<int> totalLength(
  Future<String> Function() first,
  Future<String> Function() second,
) => throw UnimplementedError();

/// 4. Return the job's value. If it takes over 1 second, return 'too slow'.
Future<String> withinOneSecond(Future<String> job) =>
    throw UnimplementedError();

/// 5. Use async* and yield. countDown(3) gives 3, 2, 1, 0.
Stream<int> countDown(int from) => throw UnimplementedError();

/// 6. Add up a stream, using await for.
Future<int> sumStream(Stream<int> numbers) => throw UnimplementedError();

/// 7. Keep words longer than 3 letters, and make them upper case.
/// Use where and map on the stream.
Stream<String> onlyLong(Stream<String> words) => throw UnimplementedError();

/// This is heavy work, and it's already written for you.
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

/// 8. Run countPrimes on another isolate, using Isolate.run.
Future<int> countPrimesInBackground(int upTo) => throw UnimplementedError();
