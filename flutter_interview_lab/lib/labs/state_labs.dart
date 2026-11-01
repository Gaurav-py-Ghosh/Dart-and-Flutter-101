// The same counter written six ways, so you can compare state management.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

class CounterView extends StatelessWidget {
  const CounterView({super.key, required this.count, required this.onAdd});
  final int count;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Text('$count', style: Theme.of(context).textTheme.headlineSmall),
        IconButton.filled(
          onPressed: onAdd,
          tooltip: 'Add',
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

// 1. setState: for state only one widget cares about.
class SetStateCounter extends StatefulWidget {
  const SetStateCounter({super.key});

  @override
  State<SetStateCounter> createState() => _SetStateCounterState();
}

class _SetStateCounterState extends State<SetStateCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return CounterView(
      count: _count,
      onAdd: () => setState(() => _count++),
    );
  }
}

// 2. ValueNotifier: one value, rebuilds only the builder.
class NotifierCounter extends StatefulWidget {
  const NotifierCounter({super.key});

  @override
  State<NotifierCounter> createState() => _NotifierCounterState();
}

class _NotifierCounterState extends State<NotifierCounter> {
  final _count = ValueNotifier<int>(0);

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _count,
      builder: (context, value, _) =>
          CounterView(count: value, onAdd: () => _count.value++),
    );
  }
}

// 3. InheritedWidget: Flutter's built-in way to pass data down the tree.
// Provider is built on top of this idea.
class CountScope extends InheritedWidget {
  const CountScope({
    super.key,
    required this.count,
    required this.onAdd,
    required super.child,
  });
  final int count;
  final VoidCallback onAdd;

  static CountScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CountScope>()!;

  // Rebuild the widgets that depend on this only if the value changed.
  @override
  bool updateShouldNotify(CountScope oldWidget) => oldWidget.count != count;
}

class InheritedCounter extends StatefulWidget {
  const InheritedCounter({super.key});

  @override
  State<InheritedCounter> createState() => _InheritedCounterState();
}

class _InheritedCounterState extends State<InheritedCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return CountScope(
      count: _count,
      onAdd: () => setState(() => _count++),
      child: const _DeepChild(),
    );
  }
}

class _DeepChild extends StatelessWidget {
  const _DeepChild();

  @override
  Widget build(BuildContext context) {
    final scope = CountScope.of(context);
    return CounterView(count: scope.count, onAdd: scope.onAdd);
  }
}

// 4. Provider with ChangeNotifier.
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void add() {
    _count++;
    notifyListeners();
  }
}

class ProviderCounter extends StatelessWidget {
  const ProviderCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return p.ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: p.Consumer<CounterModel>(
        builder: (context, model, _) =>
            CounterView(count: model.count, onAdd: model.add),
      ),
    );
  }
}

// 5. Riverpod: providers live outside the widget tree.
class RiverpodCounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void add() => state++;
}

final riverpodCounter = NotifierProvider<RiverpodCounterNotifier, int>(
  RiverpodCounterNotifier.new,
);

class RiverpodCounter extends StatelessWidget {
  const RiverpodCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) => CounterView(
          count: ref.watch(riverpodCounter),
          onAdd: () => ref.read(riverpodCounter.notifier).add(),
        ),
      ),
    );
  }
}

// 6a. Cubit: call a method, emit a new state.
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void add() => emit(state + 1);
}

class CubitCounter extends StatelessWidget {
  const CubitCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocBuilder<CounterCubit, int>(
        builder: (context, count) => CounterView(
          count: count,
          onAdd: () => context.read<CounterCubit>().add(),
        ),
      ),
    );
  }
}

// 6b. Bloc: send an event, the bloc turns it into new state.
sealed class CounterEvent {}

class AddPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<AddPressed>((event, emit) => emit(state + 1));
  }
}

class BlocCounter extends StatelessWidget {
  const BlocCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: BlocBuilder<CounterBloc, int>(
        builder: (context, count) => CounterView(
          count: count,
          onAdd: () => context.read<CounterBloc>().add(AddPressed()),
        ),
      ),
    );
  }
}

class StateLab extends StatelessWidget {
  const StateLab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget row(String title, Widget counter) => Card(
      child: ListTile(title: Text(title), trailing: SizedBox(width: 140, child: counter)),
    );
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        row('setState', const SetStateCounter()),
        row('ValueNotifier', const NotifierCounter()),
        row('InheritedWidget', const InheritedCounter()),
        row('Provider', const ProviderCounter()),
        row('Riverpod', const RiverpodCounter()),
        row('Cubit', const CubitCounter()),
        row('Bloc', const BlocCounter()),
      ],
    );
  }
}
