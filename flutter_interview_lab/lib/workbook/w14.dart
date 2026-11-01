// NOTE 14 WORKBOOK.
// Check it:  flutter test workbook_test/w14_test.dart
// Answers are in lib/workbook_answers/w14.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';

/// 1. IMPLICIT ANIMATION. Show Text('Fade me') inside an AnimatedOpacity.
/// Opacity is 1 if visible, or else 0. Duration is 300 milliseconds.
class FadeBox extends StatelessWidget {
  const FadeBox({super.key, required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 2. EXPLICIT ANIMATION. Show Text('Pulse') inside a ScaleTransition, driven
/// by an AnimationController that repeats forever. Dispose the controller.
/// The test checks that the widget really is animating.
class Pulse extends StatefulWidget {
  const Pulse({super.key});

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 3. THEMES. Use a teal colorSchemeSeed in both. The dark one has
/// brightness: Brightness.dark.
ThemeData buildLightTheme() => throw UnimplementedError();
ThemeData buildDarkTheme() => throw UnimplementedError();

/// 4. A Container whose color comes from the theme's colorScheme.primary.
/// No hard-coded color.
class BrandBox extends StatelessWidget {
  const BrandBox({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. ACCESSIBILITY. An Icon(Icons.delete) wrapped in Semantics, with the label
/// 'Delete item' and button: true.
class LabelledIcon extends StatelessWidget {
  const LabelledIcon({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
