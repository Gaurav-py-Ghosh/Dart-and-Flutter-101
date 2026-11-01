import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w08.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  test('1 validateEmail', () {
    expect(validateEmail(null), 'Email is required');
    expect(validateEmail(''), 'Email is required');
    expect(validateEmail('nope'), 'Invalid email');
    expect(validateEmail('a@b'), 'Invalid email');
    expect(validateEmail('a@b.com'), isNull);
  });

  test('2 validatePassword', () {
    expect(validatePassword(null), 'Use at least 8 characters');
    expect(validatePassword('short'), 'Use at least 8 characters');
    expect(validatePassword('longenough'), isNull);
  });

  testWidgets('3 LoginForm', (tester) async {
    String? loggedIn;
    await tester.pumpWidget(wrap(LoginForm(onLogin: (e) => loggedIn = e)));

    await tester.tap(find.text('Log in'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(loggedIn, isNull);

    await tester.enterText(find.byKey(const Key('email')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('password')), 'longenough');
    await tester.tap(find.text('Log in'));
    await tester.pump();
    expect(loggedIn, 'a@b.com');
  });

  testWidgets('4 and 5 ColorChooser gets a value back', (tester) async {
    await tester.pumpWidget(wrap(const ColorChooser()));
    expect(find.text('Chosen: None'), findsOneWidget);

    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorPage), findsOneWidget);

    await tester.tap(find.text('Red'));
    await tester.pumpAndSettle();
    expect(find.text('Chosen: Red'), findsOneWidget);
  });

  testWidgets('5 back with no choice keeps the value', (tester) async {
    await tester.pumpWidget(wrap(const ColorChooser()));
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Chosen: None'), findsOneWidget);
  });

  testWidgets('6 and 7 data goes forward', (tester) async {
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => openGreeting(context, 'Asha'),
            child: const Text('Go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    expect(find.text('Hello Asha'), findsOneWidget);
  });
}
