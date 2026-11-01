// NOTE 07 WORKBOOK. Write each widget yourself.
// Each class here is a StatefulWidget with an empty State. Add what's missing.
// Check it:  flutter test workbook_test/w07_test.dart
// Answers are in lib/workbook_answers/w07.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';

/// 1. A TextButton showing 'Tapped 0 times'. Each tap adds 1. Use setState.
class TapCounter extends StatefulWidget {
  const TapCounter({super.key});

  @override
  State<TapCounter> createState() => _TapCounterState();
}

class _TapCounterState extends State<TapCounter> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 2. A Column holding a TextButton, and Text('Secret') that shows only when
/// visible. The button says 'Show' when hidden, and 'Hide' when visible.
/// It starts hidden.
class ShowHide extends StatefulWidget {
  const ShowHide({super.key});

  @override
  State<ShowHide> createState() => _ShowHideState();
}

class _ShowHideState extends State<ShowHide> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 3. Show the seconds left as Text, counting down once a second.
/// Start a Timer.periodic in initState (import 'dart:async').
/// Stop at 0. CANCEL THE TIMER IN dispose. The test checks this.
class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.seconds});
  final int seconds;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 4. Show the value as Text. When the parent sends a different value, call
/// widget.onChanged(oldValue, newValue). Use didUpdateWidget.
class ValueWatcher extends StatefulWidget {
  const ValueWatcher({super.key, required this.value, required this.onChanged});
  final int value;
  final void Function(int oldValue, int newValue) onChanged;

  @override
  State<ValueWatcher> createState() => _ValueWatcherState();
}

class _ValueWatcherState extends State<ValueWatcher> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. A Column with a TextField, and Text('You typed: <text>') that updates as
/// you type. Use a TextEditingController, and dispose it.
class EchoField extends StatefulWidget {
  const EchoField({super.key});

  @override
  State<EchoField> createState() => _EchoFieldState();
}

class _EchoFieldState extends State<EchoField> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 6. Show Text('Loading'). Call widget.load() from initState, then show the
/// result. If the widget has gone by then, don't call setState: check mounted.
class SlowLoader extends StatefulWidget {
  const SlowLoader({super.key, required this.load});
  final Future<String> Function() load;

  @override
  State<SlowLoader> createState() => _SlowLoaderState();
}

class _SlowLoaderState extends State<SlowLoader> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 7. A Column with one TapCounter for each name, each with a ValueKey(name),
/// so that a counter's taps stay with its name when the order changes.
class KeyedNames extends StatelessWidget {
  const KeyedNames({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
