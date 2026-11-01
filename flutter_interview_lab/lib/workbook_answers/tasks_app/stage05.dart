// YOUR FIRST APP, finished version from note 05.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage05.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const FirstApp());
}

class FirstApp extends StatelessWidget {
  const FirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build: count is $_count');
    return Scaffold(
      appBar: AppBar(title: const Text('My first app')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Taps: $_count'),
            const NormalLabel(),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Text('Tap me'),
            ),
          ],
        ),
      ),
    );
  }
}

class NormalLabel extends StatelessWidget {
  const NormalLabel({super.key});

  @override
  Widget build(BuildContext context) {
    print('NormalLabel build');
    return const Text('I never change');
  }
}
