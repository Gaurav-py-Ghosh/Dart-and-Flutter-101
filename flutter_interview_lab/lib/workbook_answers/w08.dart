// ANSWERS for note 08. Try lib/workbook/w08.dart first.

import 'package:flutter/material.dart';

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!value.contains('@') || !value.contains('.')) return 'Invalid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 8) return 'Use at least 8 characters';
  return null;
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onLogin});
  final void Function(String email) onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('email'),
            controller: _email,
            validator: validateEmail,
          ),
          TextFormField(
            key: const Key('password'),
            controller: _password,
            obscureText: true,
            validator: validatePassword,
          ),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onLogin(_email.text);
              }
            },
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }
}

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a color')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop('Red'),
          child: const Text('Red'),
        ),
      ),
    );
  }
}

class ColorChooser extends StatefulWidget {
  const ColorChooser({super.key});

  @override
  State<ColorChooser> createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  String _chosen = 'None';

  Future<void> _open() async {
    final color = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ColorPage()),
    );
    if (color == null || !mounted) return;
    setState(() => _chosen = color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Chosen: $_chosen'),
        TextButton(onPressed: _open, child: const Text('Choose')),
      ],
    );
  }
}

class GreetingPage extends StatelessWidget {
  const GreetingPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Hello $name'));
  }
}

void openGreeting(BuildContext context, String name) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => GreetingPage(name: name)),
  );
}
