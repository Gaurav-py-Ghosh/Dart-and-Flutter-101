// App labs: navigation, async UI, saving data, performance,
// native calls, and search with paging.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../architecture/todo_architecture.dart';

// ---------- NAVIGATOR: pages stack up like plates ----------
class NavigatorLab extends StatefulWidget {
  const NavigatorLab({super.key});

  @override
  State<NavigatorLab> createState() => _NavigatorLabState();
}

class _NavigatorLabState extends State<NavigatorLab> {
  String _answer = 'Nothing yet';

  Future<void> _open() async {
    // push gives back a Future that finishes when the page pops.
    final answer = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const PickerPage(title: 'Pick one')),
    );
    if (!mounted) return; // the screen may have closed during the await
    setState(() => _answer = answer ?? 'You pressed back');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text('Result from second page: $_answer'),
          FilledButton(onPressed: _open, child: const Text('Open page')),
        ],
      ),
    );
  }
}

class PickerPage extends StatelessWidget {
  const PickerPage({super.key, required this.title});
  final String title; // data passed through the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop('Mango'),
          child: const Text('Choose Mango and go back'),
        ),
      ),
    );
  }
}

// ---------- GO_ROUTER: pages as URLs, good for web and deep links ----------
final GoRouter labRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          // This lab has its own Navigator, so go back to the lab menu directly.
          leading: BackButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
        body: Center(
          child: FilledButton(
            onPressed: () => context.push('/product/42?color=red'),
            child: const Text('Open product 42'),
          ),
        ),
      ),
      routes: [
        GoRoute(
          path: 'product/:id',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text('Product ${state.pathParameters['id']}')),
            body: Center(
              child: Text('Color: ${state.uri.queryParameters['color']}'),
            ),
          ),
        ),
      ],
    ),
  ],
);

class GoRouterLab extends StatelessWidget {
  const GoRouterLab({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: labRouter,
  );
}

// ---------- ASYNC UI: FutureBuilder and StreamBuilder ----------
class AsyncLab extends StatefulWidget {
  const AsyncLab({super.key});

  @override
  State<AsyncLab> createState() => _AsyncLabState();
}

class _AsyncLabState extends State<AsyncLab> {
  // Keep the Future in a field. If you create it inside build(), every
  // rebuild starts a brand new request. This is a classic bug.
  late final Future<String> _profile = Future.delayed(
    const Duration(seconds: 2),
    () => 'Asha loaded',
  );
  late final Stream<int> _ticks = Stream.periodic(
    const Duration(seconds: 1),
    (count) => count,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          FutureBuilder<String>(
            future: _profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Text(snapshot.data!);
            },
          ),
          StreamBuilder<int>(
            stream: _ticks,
            builder: (context, snapshot) =>
                Text('Seconds: ${snapshot.data ?? 0}'),
          ),
        ],
      ),
    );
  }
}

// ---------- ARCHITECTURE: the complete layered screen ----------
class ArchitectureLab extends StatefulWidget {
  const ArchitectureLab({super.key});

  @override
  State<ArchitectureLab> createState() => _ArchitectureLabState();
}

class _ArchitectureLabState extends State<ArchitectureLab> {
  bool _serverBroken = false;
  late final TodoViewModel _viewModel = TodoViewModel(
    ApiTodoRepository(fakeServer(shouldFail: () => _serverBroken)),
  )..load();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Break the server, then reload'),
          value: _serverBroken,
          onChanged: (value) {
            setState(() => _serverBroken = value);
            _viewModel.load();
          },
        ),
        Expanded(child: TodoScreen(viewModel: _viewModel)),
      ],
    );
  }
}

// ---------- SAVING DATA: survives an app restart ----------
class StorageLab extends StatefulWidget {
  const StorageLab({super.key});

  @override
  State<StorageLab> createState() => _StorageLabState();
}

class _StorageLabState extends State<StorageLab> {
  int _opens = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final opens = (prefs.getInt('opens') ?? 0) + 1;
    await prefs.setInt('opens', opens);
    if (mounted) setState(() => _opens = opens);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('You opened this lab $_opens times. Restart the app and see.'),
    );
  }
}

// ---------- PERFORMANCE ----------
int slowSum(int upTo) {
  var total = 0;
  for (var i = 0; i < upTo; i++) {
    total += i;
  }
  return total;
}

class PerformanceLab extends StatefulWidget {
  const PerformanceLab({super.key});

  @override
  State<PerformanceLab> createState() => _PerformanceLabState();
}

class _PerformanceLabState extends State<PerformanceLab> {
  String _result = 'Press a button and watch the spinner';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const CircularProgressIndicator(),
          Text(_result),
          FilledButton(
            onPressed: () {
              // Runs on the UI isolate: the spinner freezes.
              setState(() => _result = 'Blocked UI: ${slowSum(10000000000)}');
            },
            child: const Text('Run on UI thread (freezes)'),
          ),
          FilledButton(
            onPressed: () async {
              // compute uses another isolate: the spinner keeps turning.
              final value = await compute(slowSum, 10000000000);
              if (mounted) setState(() => _result = 'Smooth: $value');
            },
            child: const Text('Run with compute (smooth)'),
          ),
        ],
      ),
    );
  }
}

// ---------- NATIVE CALLS: how Dart talks to Android and iOS ----------
class ChannelLab extends StatefulWidget {
  const ChannelLab({super.key});

  @override
  State<ChannelLab> createState() => _ChannelLabState();
}

class _ChannelLabState extends State<ChannelLab> {
  static const _channel = MethodChannel('lab/battery');
  String _status = 'Not called yet';

  Future<void> _call() async {
    String status;
    try {
      final level = await _channel.invokeMethod<int>('getBatteryLevel');
      status = 'Battery: $level%';
    } on MissingPluginException {
      status = 'No native code answered. Expected here, as none is written.';
    } on PlatformException catch (e) {
      status = 'Native side failed: ${e.message}';
    }
    if (mounted) setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(_status),
          FilledButton(onPressed: _call, child: const Text('Call native')),
        ],
      ),
    );
  }
}

// ---------- SEARCH WITH DEBOUNCE AND INFINITE SCROLL ----------
// This is a very common live coding task.
class SearchLab extends StatefulWidget {
  const SearchLab({super.key, this.pageSize = 20, this.delay = const Duration(milliseconds: 400)});
  final int pageSize;
  final Duration delay;

  @override
  State<SearchLab> createState() => _SearchLabState();
}

class _SearchLabState extends State<SearchLab> {
  static final _all = List.generate(200, (i) => 'Item ${i + 1}');
  final _scroll = ScrollController();
  Timer? _debounce;
  String _query = '';
  int _shown = 20;

  List<String> get _matches => _all
      .where((item) => item.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  void initState() {
    super.initState();
    _shown = widget.pageSize;
    _scroll.addListener(() {
      final nearBottom =
          _scroll.position.pixels > _scroll.position.maxScrollExtent - 200;
      if (nearBottom && _shown < _matches.length) {
        setState(() => _shown += widget.pageSize);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  // Each key press cancels the old timer. Only the last one fires.
  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(widget.delay, () {
      setState(() {
        _query = text;
        _shown = widget.pageSize;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = _matches.take(_shown).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            key: const Key('search'),
            onChanged: _onChanged,
            decoration: const InputDecoration(labelText: 'Search'),
          ),
        ),
        Text('Showing ${visible.length} of ${_matches.length}'),
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            itemCount: visible.length,
            itemBuilder: (context, index) =>
                ListTile(title: Text(visible[index])),
          ),
        ),
      ],
    );
  }
}
