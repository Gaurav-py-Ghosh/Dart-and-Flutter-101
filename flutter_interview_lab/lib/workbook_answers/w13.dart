// ANSWERS for note 13. Try lib/workbook/w13.dart first.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Probe extends StatelessWidget {
  const Probe({super.key, required this.onBuild});
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const Text('Probe');
  }
}

class FastCounter extends StatefulWidget {
  const FastCounter({super.key, required this.child});
  final Widget child;

  @override
  State<FastCounter> createState() => _FastCounterState();
}

class _FastCounterState extends State<FastCounter> {
  final _count = ValueNotifier<int>(0);

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _count,
          builder: (context, count, _) => TextButton(
            onPressed: () => _count.value++,
            child: Text('Count: $count'),
          ),
        ),
        widget.child,
      ],
    );
  }
}

int _sumJson(String body) {
  final numbers = jsonDecode(body) as List<dynamic>;
  return numbers.cast<int>().fold(0, (total, n) => total + n);
}

Future<int> sumJsonInBackground(String body) => compute(_sumJson, body);

class HugeList extends StatelessWidget {
  const HugeList({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      itemExtent: 56,
      itemBuilder: (context, index) => Text('Row $index'),
    );
  }
}
