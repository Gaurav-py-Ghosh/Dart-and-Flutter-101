// Short examples used in the notes. They aren't lab screens.
// This file exists so that the analyzer proves each one compiles.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetTour extends StatelessWidget {
  const WidgetTour({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Big bold title',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text('Theme text', style: Theme.of(context).textTheme.titleLarge),
        const Icon(Icons.star, color: Colors.amber, size: 32),
        Image.asset('assets/photo.png', width: 100, fit: BoxFit.cover),
        Image.network('https://example.com/a.png', cacheWidth: 200),
        Container(
          width: 200,
          height: 80,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black),
          ),
          child: const Text('Styled box'),
        ),
        const Align(alignment: Alignment.topRight, child: Text('Corner')),
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        TextButton(onPressed: () {}, child: const Text('Text')),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        const ElevatedButton(onPressed: null, child: Text('Disabled')),
        const Divider(),
        GestureDetector(
          onTap: () => print('Tapped'),
          child: const Text('Tap anything'),
        ),
        InkWell(onTap: () {}, child: const Text('Tap with a ripple')),
        const Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Asha'),
            subtitle: Text('Developer'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 100,
            itemBuilder: (context, index) => Text('Cell $index'),
          ),
        ),
      ],
    );
  }
}

class ScaffoldTour extends StatelessWidget {
  const ScaffoldTour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Saved')));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: const SingleChildScrollView(child: Text('Scrolls if too long')),
    );
  }
}

// Using a context from below MaterialApp.
class BuilderExample extends StatelessWidget {
  const BuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (innerContext) => TextButton(
          onPressed: () => Navigator.of(innerContext).pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}

// Running something after the current frame has finished.
class AfterFrame extends StatefulWidget {
  const AfterFrame({super.key});

  @override
  State<AfterFrame> createState() => _AfterFrameState();
}

class _AfterFrameState extends State<AfterFrame> {
  bool _ready = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_ready) setState(() => _ready = true);
    });
    return Text('Ready: $_ready');
  }
}

// Dialogs wait for an answer, just like pages.
Future<void> confirmDelete(BuildContext context) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  if (yes == true) print('Deleted');
}

// Protecting a screen behind login.
bool isLoggedIn = false;

final protectedRouter = GoRouter(
  redirect: (context, state) {
    final goingToLogin = state.matchedLocation == '/login';
    if (!isLoggedIn && !goingToLogin) return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Text('Home')),
    GoRoute(path: '/login', builder: (context, state) => const Text('Login')),
  ],
);

// Text input options.
class FieldOptions extends StatelessWidget {
  const FieldOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      obscureText: false,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'you@example.com',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
    );
  }
}

// Stream subscription cleaned up in dispose.
class LiveLabel extends StatefulWidget {
  const LiveLabel({super.key, required this.source});
  final Stream<int> source;

  @override
  State<LiveLabel> createState() => _LiveLabelState();
}

class _LiveLabelState extends State<LiveLabel> {
  late final subscription = widget.source.listen((value) {
    setState(() => _value = value);
  });
  int _value = 0;

  @override
  void initState() {
    super.initState();
    subscription;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text('$_value');
}
