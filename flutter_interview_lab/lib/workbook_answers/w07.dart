// ANSWERS for note 07. Try lib/workbook/w07.dart first.

import 'dart:async';

import 'package:flutter/material.dart';

class TapCounter extends StatefulWidget {
  const TapCounter({super.key});

  @override
  State<TapCounter> createState() => _TapCounterState();
}

class _TapCounterState extends State<TapCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => setState(() => _count++),
      child: Text('Tapped $_count times'),
    );
  }
}

class ShowHide extends StatefulWidget {
  const ShowHide({super.key});

  @override
  State<ShowHide> createState() => _ShowHideState();
}

class _ShowHideState extends State<ShowHide> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Hide' : 'Show'),
        ),
        if (_visible) const Text('Secret'),
      ],
    );
  }
}

class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.seconds});
  final int seconds;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left = widget.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _left--);
      if (_left == 0) timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text('$_left');
}

class ValueWatcher extends StatefulWidget {
  const ValueWatcher({super.key, required this.value, required this.onChanged});
  final int value;
  final void Function(int oldValue, int newValue) onChanged;

  @override
  State<ValueWatcher> createState() => _ValueWatcherState();
}

class _ValueWatcherState extends State<ValueWatcher> {
  @override
  void didUpdateWidget(ValueWatcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      widget.onChanged(oldWidget.value, widget.value);
    }
  }

  @override
  Widget build(BuildContext context) => Text('${widget.value}');
}

class EchoField extends StatefulWidget {
  const EchoField({super.key});

  @override
  State<EchoField> createState() => _EchoFieldState();
}

class _EchoFieldState extends State<EchoField> {
  final _controller = TextEditingController();
  String _echo = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (text) => setState(() => _echo = text),
        ),
        Text('You typed: $_echo'),
      ],
    );
  }
}

class SlowLoader extends StatefulWidget {
  const SlowLoader({super.key, required this.load});
  final Future<String> Function() load;

  @override
  State<SlowLoader> createState() => _SlowLoaderState();
}

class _SlowLoaderState extends State<SlowLoader> {
  String _text = 'Loading';

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final result = await widget.load();
    if (!mounted) return;
    setState(() => _text = result);
  }

  @override
  Widget build(BuildContext context) => Text(_text);
}

class KeyedNames extends StatelessWidget {
  const KeyedNames({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final name in names) TapCounter(key: ValueKey(name)),
      ],
    );
  }
}
