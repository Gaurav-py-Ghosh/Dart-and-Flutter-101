// NOTE 13 WORKBOOK. Tests count rebuilds, so a slow answer really fails.
// Check it:  flutter test workbook_test/w13_test.dart
// Answers are in lib/workbook_answers/w13.dart. Try for 5 minutes first.
//
// You'll need these imports for some answers:
//   import 'dart:convert';                 (jsonDecode)
//   import 'package:flutter/foundation.dart';  (compute)

import 'package:flutter/material.dart';

/// This one is finished. It reports each time it builds.
class Probe extends StatelessWidget {
  const Probe({super.key, required this.onBuild});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const Text('Probe');
  }
}

/// 1. A Column holding a TextButton saying 'Count: <n>', and then widget.child.
/// Each tap adds 1. THE CHILD MUST NOT REBUILD WHEN YOU TAP.
/// Hint: a ValueNotifier and ValueListenableBuilder around only the button.
class FastCounter extends StatefulWidget {
  const FastCounter({super.key, required this.child});
  final Widget child;

  @override
  State<FastCounter> createState() => _FastCounterState();
}

class _FastCounterState extends State<FastCounter> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 2. Decode a JSON list of numbers like '[1,2,3]' and add them up, in another
/// isolate using compute. compute needs a top-level function, so write one.
Future<int> sumJsonInBackground(String body) => throw UnimplementedError();

/// 3. A list of 'Row <index>' that stays fast with 100,000 rows.
/// Use the lazy constructor, and set itemExtent to 56.
class HugeList extends StatelessWidget {
  const HugeList({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
