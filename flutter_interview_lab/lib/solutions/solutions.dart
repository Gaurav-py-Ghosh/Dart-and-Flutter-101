// ANSWERS to lib/challenges/challenges.dart. Try for 10 minutes first.

import 'dart:async';

bool isPalindrome(String text) {
  final clean = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  var left = 0;
  var right = clean.length - 1;
  while (left < right) {
    if (clean[left] != clean[right]) return false;
    left++;
    right--;
  }
  return true;
}

Map<String, int> wordCount(String text) {
  final counts = <String, int>{};
  for (final word in text.toLowerCase().split(RegExp(r'\s+'))) {
    if (word.isEmpty) continue;
    counts[word] = (counts[word] ?? 0) + 1;
  }
  return counts;
}

// A Dart Set remembers insertion order, so this one line is enough.
List<T> uniqueInOrder<T>(List<T> items) => items.toSet().toList();

// A map gives O(n) time. Two nested loops would be O(n * n).
(int, int)? twoSum(List<int> numbers, int target) {
  final seen = <int, int>{};
  for (var i = 0; i < numbers.length; i++) {
    final partner = seen[target - numbers[i]];
    if (partner != null) return (partner, i);
    seen[numbers[i]] = i;
  }
  return null;
}

List<Object?> flatten(List<Object?> items) => [
  for (final item in items)
    if (item is List<Object?>) ...flatten(item) else item,
];

Map<K, List<T>> groupBy<T, K>(List<T> items, K Function(T) keyOf) {
  final groups = <K, List<T>>{};
  for (final item in items) {
    groups.putIfAbsent(keyOf(item), () => []).add(item);
  }
  return groups;
}

Future<T> retry<T>(Future<T> Function() action, {int maxAttempts = 3}) async {
  for (var attempt = 1; ; attempt++) {
    try {
      return await action();
    } catch (_) {
      if (attempt >= maxAttempts) rethrow;
    }
  }
}

class Debouncer {
  Debouncer(this.delay);
  final Duration delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}

class Stack<T> {
  final _items = <T>[];

  void push(T value) => _items.add(value);
  T? pop() => _items.isEmpty ? null : _items.removeLast();
  T? peek() => _items.isEmpty ? null : _items.last;
  bool get isEmpty => _items.isEmpty;
}

// A Dart Map keeps insertion order. To mark a key as recently used, remove it
// and add it again. The first key is then always the oldest.
class LruCache<K, V> {
  LruCache(this.capacity);
  final int capacity;
  final _items = <K, V>{};

  V? get(K key) {
    if (!_items.containsKey(key)) return null;
    final value = _items.remove(key) as V;
    _items[key] = value;
    return value;
  }

  void put(K key, V value) {
    _items.remove(key);
    if (_items.length >= capacity) _items.remove(_items.keys.first);
    _items[key] = value;
  }
}
