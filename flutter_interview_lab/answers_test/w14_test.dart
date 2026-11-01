import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook_answers/w14.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('1 FadeBox', (tester) async {
    await tester.pumpWidget(wrap(const FadeBox(visible: true)));
    expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        1);
    await tester.pumpWidget(wrap(const FadeBox(visible: false)));
    expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0);
  });

  testWidgets('2 Pulse animates, and cleans up', (tester) async {
    await tester.pumpWidget(wrap(const Pulse()));
    // Page transitions use ScaleTransition too, so look only around our text.
    final scale = find.ancestor(
      of: find.text('Pulse'),
      matching: find.byType(ScaleTransition),
    );
    expect(scale, findsWidgets);
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    // Removing it must dispose the controller, or the test reports a ticker.
    await tester.pumpWidget(wrap(const SizedBox()));
    expect(tester.hasRunningAnimations, isFalse);
  });

  test('3 themes', () {
    expect(buildLightTheme().brightness, Brightness.light);
    expect(buildDarkTheme().brightness, Brightness.dark);
    expect(
      buildLightTheme().colorScheme.primary,
      ColorScheme.fromSeed(seedColor: Colors.teal).primary,
    );
  });

  testWidgets('4 BrandBox follows the theme', (tester) async {
    final theme = buildLightTheme();
    await tester.pumpWidget(
      MaterialApp(theme: theme, home: const BrandBox()),
    );
    final box = tester.widget<Container>(find.byType(Container));
    expect(box.color, theme.colorScheme.primary);
  });

  testWidgets('5 LabelledIcon', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(wrap(const Center(child: LabelledIcon())));
    expect(find.bySemanticsLabel('Delete item'), findsOneWidget);
    handle.dispose();
  });
}
