// UI labs: layout, responsive screens, lifecycle, keys, forms, animation.

import 'dart:math';

import 'package:flutter/material.dart';

// ---------- LAYOUT ----------
class LayoutLab extends StatelessWidget {
  const LayoutLab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Row with Expanded: flex shares the free space 2 to 1'),
        Row(
          children: [
            Container(width: 60, height: 50, color: Colors.red),
            Expanded(flex: 2, child: Container(height: 50, color: Colors.green)),
            Expanded(child: Container(height: 50, color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Stack: children sit on top of each other'),
        SizedBox(
          height: 90,
          child: Stack(
            children: [
              Container(color: Colors.amber),
              const Positioned(right: 8, bottom: 8, child: Icon(Icons.star)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Wrap: flows onto a new line instead of overflowing'),
        Wrap(
          spacing: 8,
          children: [
            for (var i = 1; i <= 30; i++) Chip(label: Text('Tag $i')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Constraints: parent says 100 wide, child asks for 500'),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 100, height: 50),
          child: Container(width: 500, color: Colors.purple),
        ),
        const SizedBox(height: 16),
        const Text('LayoutBuilder: changes with the space available'),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Container(
              height: 50,
              alignment: Alignment.center,
              color: isWide ? Colors.teal : Colors.orange,
              child: Text(
                '${isWide ? 'Wide' : 'Narrow'} layout: '
                '${constraints.maxWidth.toInt()} px. Resize the window!',
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------- LIFECYCLE ----------
class LifecycleLab extends StatefulWidget {
  const LifecycleLab({super.key});

  @override
  State<LifecycleLab> createState() => _LifecycleLabState();
}

class _LifecycleLabState extends State<LifecycleLab> {
  int _parentValue = 0;
  bool _showChild = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const Text('Watch the Debug Console while you press these'),
          if (_showChild) LifecycleChild(value: _parentValue),
          FilledButton(
            onPressed: () => setState(() => _parentValue++),
            child: const Text('Parent sends a new value'),
          ),
          OutlinedButton(
            onPressed: () => setState(() => _showChild = !_showChild),
            child: Text(_showChild ? 'Remove child' : 'Add child'),
          ),
        ],
      ),
    );
  }
}

class LifecycleChild extends StatefulWidget {
  const LifecycleChild({super.key, required this.value});
  final int value;

  @override
  // The print is only here for the lesson. Real code keeps this method empty.
  // ignore: no_logic_in_create_state
  State<LifecycleChild> createState() {
    print('1. createState');
    return _LifecycleChildState();
  }
}

class _LifecycleChildState extends State<LifecycleChild> {
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    print('2. initState: runs once. Start controllers and listeners here');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('3. didChangeDependencies: safe to read Theme.of(context) here');
  }

  @override
  void didUpdateWidget(LifecycleChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget: parent value ${oldWidget.value} -> ${widget.value}');
  }

  @override
  void deactivate() {
    print('deactivate: leaving the tree');
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose: gone for good. Clean up here');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('4. build');
    return OutlinedButton(
      onPressed: () => setState(() => _taps++),
      child: Text('Parent: ${widget.value}, my taps: $_taps'),
    );
  }
}

// ---------- KEYS ----------
class KeysLab extends StatefulWidget {
  const KeysLab({super.key});

  @override
  State<KeysLab> createState() => _KeysLabState();
}

class _KeysLabState extends State<KeysLab> {
  final _names = ['Asha', 'Ravi', 'Meera'];

  void _swap() => setState(() => _names.insert(0, _names.removeLast()));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Type in each box, then press Rotate.'),
        FilledButton(onPressed: _swap, child: const Text('Rotate')),
        const SizedBox(height: 16),
        const Text('WITHOUT keys: labels move, typed text stays behind (bug)'),
        for (final name in _names) NameField(name: name),
        const SizedBox(height: 16),
        const Text('WITH ValueKey: typed text moves with its name (correct)'),
        for (final name in _names) NameField(key: ValueKey(name), name: name),
      ],
    );
  }
}

class NameField extends StatefulWidget {
  const NameField({super.key, required this.name});
  final String name;

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.name),
    );
  }
}

// ---------- FORMS ----------
class FormLab extends StatefulWidget {
  const FormLab({super.key});

  @override
  State<FormLab> createState() => _FormLabState();
}

class _FormLabState extends State<FormLab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _message = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _message = 'Welcome ${_emailController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          children: [
            TextFormField(
              key: const Key('email'),
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'That is not an email';
                return null; // null means valid
              },
            ),
            FilledButton(onPressed: _submit, child: const Text('Submit')),
            Text(_message),
          ],
        ),
      ),
    );
  }
}

// ---------- ANIMATION ----------
class AnimationLab extends StatefulWidget {
  const AnimationLab({super.key});

  @override
  State<AnimationLab> createState() => _AnimationLabState();
}

// SingleTickerProviderStateMixin gives the controller a tick for each frame.
class _AnimationLabState extends State<AnimationLab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  bool _big = false;

  @override
  void dispose() {
    _spin.dispose(); // forget this and the ticker keeps running
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          const Text('Implicit: change a value, Flutter animates the change'),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _big ? 180 : 80,
            height: 80,
            color: _big ? Colors.teal : Colors.orange,
          ),
          FilledButton(
            onPressed: () => setState(() => _big = !_big),
            child: const Text('Toggle'),
          ),
          const Text('Explicit: you drive it with an AnimationController'),
          // AnimatedBuilder rebuilds only this part on each tick.
          // `child` is built once and reused, which saves work.
          AnimatedBuilder(
            animation: _spin,
            child: const FlutterLogo(size: 60),
            builder: (context, child) => Transform.rotate(
              angle: _spin.value * 2 * pi,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
