// Short extra examples used in the notes. They are not lab screens.
// This file exists so that the analyzer proves each one compiles.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import 'state_labs.dart';

// Provider: three ways to read a value.
class ProviderReads extends StatelessWidget {
  const ProviderReads({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CounterModel, int>((model) => model.count);
    final whole = context.watch<CounterModel>();
    return TextButton(
      onPressed: () => context.read<CounterModel>().add(),
      child: Text('$count ${whole.count}'),
    );
  }
}

// Riverpod: watch for values, read in callbacks, listen for side effects.
class RiverpodReads extends ConsumerWidget {
  const RiverpodReads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(riverpodCounter);
    ref.listen(riverpodCounter, (previous, next) {
      if (next == 10) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ten!')));
      }
    });
    return TextButton(
      onPressed: () => ref.read(riverpodCounter.notifier).add(),
      child: Text('$count'),
    );
  }
}

// Bloc: BlocBuilder draws. BlocListener does one-time actions.
class BlocSideEffects extends StatelessWidget {
  const BlocSideEffects({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterCubit, int>(
      listener: (context, count) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Count is $count')));
      },
      child: BlocBuilder<CounterCubit, int>(
        buildWhen: (previous, current) => current.isEven,
        builder: (context, count) => Text('$count'),
      ),
    );
  }
}

// Knowing when the app goes to the background.
class AppLifecycleExample extends StatefulWidget {
  const AppLifecycleExample({super.key});

  @override
  State<AppLifecycleExample> createState() => _AppLifecycleExampleState();
}

class _AppLifecycleExampleState extends State<AppLifecycleExample> {
  late final AppLifecycleListener _listener = AppLifecycleListener(
    onPause: () => print('App went to the background'),
    onResume: () => print('App came back'),
  );

  @override
  void initState() {
    super.initState();
    _listener; // creates the listener
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

// Blocking the back button until the user confirms.
class ConfirmExit extends StatelessWidget {
  const ConfirmExit({super.key, required this.hasUnsavedWork});
  final bool hasUnsavedWork;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedWork,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) print('Ask the user to save first');
      },
      child: const SizedBox(),
    );
  }
}

// A custom list with slivers: a header that collapses, then a lazy list.
class SliverExample extends StatelessWidget {
  const SliverExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, expandedHeight: 160),
        SliverList.builder(
          itemCount: 100,
          itemBuilder: (context, index) => ListTile(title: Text('Row $index')),
        ),
      ],
    );
  }
}

// Screen size, safe area, theme, screen reader label, and a shared animation.
class SmallThings extends StatelessWidget {
  const SmallThings({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Semantics(
        label: 'Profile photo',
        child: Hero(
          tag: 'profile',
          child: RepaintBoundary(
            child: Container(
              width: width / 2,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Read a Provider value in a test or a parent: wiring a dependency down.
class Wiring extends StatelessWidget {
  const Wiring({super.key});

  @override
  Widget build(BuildContext context) {
    return p.MultiProvider(
      providers: [p.ChangeNotifierProvider(create: (_) => CounterModel())],
      child: const ProviderReads(),
    );
  }
}
