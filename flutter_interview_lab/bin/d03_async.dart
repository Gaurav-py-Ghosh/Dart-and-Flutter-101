// DART LESSON 3: async, the event loop, streams and isolates
// Run with:  dart run bin/d03_async.dart

import 'dart:async';
import 'dart:isolate';

void section(String title) => print('\n=== $title ===');

Future<String> fetchName() async {
  await Future.delayed(const Duration(milliseconds: 100));
  return 'Asha';
}

Future<String> failing() async {
  await Future.delayed(const Duration(milliseconds: 50));
  throw Exception('Server down');
}

// Classic interview question. Guess the print order before you run it.
Future<void> eventLoopOrder() async {
  print('1 normal code');
  Future(() => print('5 event queue (a normal Future)'));
  scheduleMicrotask(() => print('3 microtask queue'));
  Future.value().then((_) => print('4 then on a finished Future is a microtask'));
  print('2 normal code again');
  await Future.delayed(const Duration(milliseconds: 50));
}

Stream<int> countTo(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(const Duration(milliseconds: 20));
    yield i;
  }
}

Iterable<int> evens(int max) sync* {
  for (var i = 2; i <= max; i += 2) {
    yield i;
  }
}

int heavySum(int upTo) {
  var total = 0;
  for (var i = 0; i < upTo; i++) {
    total += i;
  }
  return total;
}

Future<void> main() async {
  section('Event loop order');
  await eventLoopOrder();

  section('async and await');
  print(await fetchName());

  section('Handling errors');
  try {
    await failing();
  } catch (e) {
    print('Caught: $e');
  }

  section('One after another vs all together');
  final watch = Stopwatch()..start();
  await fetchName();
  await fetchName();
  print('One by one took about 200 ms: ${watch.elapsedMilliseconds} ms');

  watch.reset();
  final both = await Future.wait([fetchName(), fetchName()]);
  print('Future.wait took about 100 ms: ${watch.elapsedMilliseconds} ms $both');

  section('Timeout');
  try {
    await fetchName().timeout(const Duration(milliseconds: 10));
  } on TimeoutException {
    print('Too slow, timed out');
  }

  section('Streams');
  await for (final n in countTo(3)) {
    print('await for got $n');
  }
  final squares = await countTo(4)
      .where((n) => n.isEven)
      .map((n) => n * n)
      .toList();
  print('even squares: $squares');

  section('StreamController: single vs broadcast');
  final controller = StreamController<String>.broadcast();
  final first = controller.stream.listen((m) => print('Listener 1: $m'));
  final second = controller.stream.listen((m) => print('Listener 2: $m'));
  controller.add('Hello');
  await Future.delayed(Duration.zero);
  // Always clean up, or you leak memory.
  await first.cancel();
  await second.cancel();
  await controller.close();

  final single = StreamController<int>();
  single.stream.listen((_) {});
  try {
    single.stream.listen((_) {});
  } on StateError catch (e) {
    print('A single stream allows one listener: ${e.message}');
  }
  await single.close();

  section('Generators');
  print('sync* gives: ${evens(6).toList()}');

  section('Isolates: real parallel work with separate memory');
  final result = await Isolate.run(() => heavySum(100000000));
  print('Heavy sum from another isolate: $result');
}
