// ANSWERS for note 14. Try lib/workbook/w14.dart first.

import 'package:flutter/material.dart';

class FadeBox extends StatelessWidget {
  const FadeBox({super.key, required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: const Text('Fade me'),
    );
  }
}

class Pulse extends StatefulWidget {
  const Pulse({super.key});

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: 0.5,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: const Text('Pulse'),
    );
  }
}

ThemeData buildLightTheme() => ThemeData(colorSchemeSeed: Colors.teal);

ThemeData buildDarkTheme() =>
    ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark);

class BrandBox extends StatelessWidget {
  const BrandBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).colorScheme.primary);
  }
}

class LabelledIcon extends StatelessWidget {
  const LabelledIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Delete item',
      button: true,
      child: const Icon(Icons.delete),
    );
  }
}
