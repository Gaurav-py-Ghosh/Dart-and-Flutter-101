// NOTE 08 WORKBOOK.
// Check it:  flutter test workbook_test/w08_test.dart
// Answers are in lib/workbook_answers/w08.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';

/// 1. Empty or null gives 'Email is required'. With no @ or no dot, it gives
/// 'Invalid email'. Otherwise null.
String? validateEmail(String? value) => throw UnimplementedError();

/// 2. Null or under 8 characters gives 'Use at least 8 characters'.
/// Otherwise null.
String? validatePassword(String? value) => throw UnimplementedError();

/// 3. A Form with two TextFormFields, using the validators above, and a
/// FilledButton saying 'Log in'. If valid, call widget.onLogin(email).
/// Give the fields these exact keys: Key('email') and Key('password').
/// Hide the password with obscureText: true. Dispose both controllers.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onLogin});
  final void Function(String email) onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 4. A Scaffold with a FilledButton saying 'Red'. Pressing it pops with 'Red'.
class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. A Column with Text('Chosen: None') and a TextButton saying 'Choose'.
/// The button pushes ColorPage, and shows the returned color. If the user comes
/// back with no choice, keep the old value. Check mounted after the await.
class ColorChooser extends StatefulWidget {
  const ColorChooser({super.key});

  @override
  State<ColorChooser> createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 6. A Scaffold showing 'Hello <name>'. The name comes in the constructor.
class GreetingPage extends StatelessWidget {
  const GreetingPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 7. Push GreetingPage, sending the name forward.
void openGreeting(BuildContext context, String name) =>
    throw UnimplementedError();
