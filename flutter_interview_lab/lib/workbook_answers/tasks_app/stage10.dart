// MY TASKS, finished stage from note 10: real API data, and an offline copy.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage10.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyTasksApp(client: http.Client()));

class Task {
  const Task({required this.id, required this.title, this.done = false});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int,
    title: json['title'] as String,
    done: json['completed'] as bool? ?? false,
  );

  final int id;
  final String title;
  final bool done;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': done,
  };

  Task copyWith({bool? done}) =>
      Task(id: id, title: title, done: done ?? this.done);
}

class TaskStore extends ChangeNotifier {
  TaskStore(this._client);

  static const _url = 'https://jsonplaceholder.typicode.com/todos?_limit=15';
  static const _cacheKey = 'tasks';

  final http.Client _client;
  List<Task> _tasks = const [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get remaining => _tasks.where((task) => !task.done).length;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _client
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception('Server replied ${response.statusCode}');
      }
      _tasks = _decode(response.body);
      await _saveCache();
    } catch (_) {
      final cached = await _readCache();
      if (cached.isEmpty) {
        _error = 'Could not load tasks. Check your internet.';
      } else {
        _tasks = cached;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggle(int id) {
    _tasks = [
      for (final task in _tasks)
        if (task.id == id) task.copyWith(done: !task.done) else task,
    ];
    notifyListeners();
    _saveCache();
  }

  void add(String title) {
    var nextId = 1;
    for (final task in _tasks) {
      if (task.id >= nextId) nextId = task.id + 1;
    }
    _tasks = [..._tasks, Task(id: nextId, title: title)];
    notifyListeners();
    _saveCache();
  }

  List<Task> _decode(String body) {
    final list = jsonDecode(body) as List<dynamic>;
    return list
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(_tasks));
  }

  Future<List<Task>> _readCache() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_cacheKey);
    return saved == null ? const [] : _decode(saved);
  }
}

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key, required this.client});

  final http.Client client;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStore(client)..load(),
      child: MaterialApp(
        title: 'My Tasks',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const TasksScreen(),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  Future<void> _openAddPage(BuildContext context) async {
    final store = context.read<TaskStore>();
    final title = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddTaskPage()),
    );
    if (title != null) store.add(title);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks (${store.remaining} left)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPage(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: _buildBody(store),
    );
  }

  Widget _buildBody(TaskStore store) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final error = store.error;
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(error),
            FilledButton(onPressed: store.load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (store.tasks.isEmpty) {
      return const Center(child: Text('Nothing to do. Nice!'));
    }
    return ListView.builder(
      itemCount: store.tasks.length,
      itemBuilder: (context, index) {
        final task = store.tasks[index];
        return CheckboxListTile(
          key: ValueKey(task.id),
          title: Text(task.title),
          value: task.done,
          onChanged: (_) => store.toggle(task.id),
        );
      },
    );
  }
}

String? validateTitle(String? value) {
  final title = value?.trim() ?? '';
  if (title.isEmpty) return 'Please enter a title';
  if (title.length < 3) return 'Use at least 3 characters';
  return null;
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_titleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: validateTitle,
              ),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
