// MY TASKS, finished stage from notes 11 to 14. It's in one file to keep it
// easy to compare. In a real app, each section would be its own file.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage11.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final repository = ApiTaskRepository(http.Client());
  runApp(MyTasksApp(viewModel: TasksViewModel(repository)..load()));
}

// ---------- DATA LAYER ----------

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

// Top level, because compute can only run a top-level or static function.
List<Task> decodeTasks(String body) {
  final list = jsonDecode(body) as List<dynamic>;
  return list
      .map((item) => Task.fromJson(item as Map<String, dynamic>))
      .toList();
}

abstract class TaskRepository {
  Future<List<Task>> fetchTasks();
  Future<void> saveTasks(List<Task> tasks);
}

class ApiTaskRepository implements TaskRepository {
  ApiTaskRepository(this._client);

  static const _url = 'https://jsonplaceholder.typicode.com/todos?_limit=15';
  static const _cacheKey = 'tasks';

  final http.Client _client;

  @override
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _client
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception('Server replied ${response.statusCode}');
      }
      final tasks = await compute(decodeTasks, response.body);
      await saveTasks(tasks);
      return tasks;
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_cacheKey);
      if (saved == null) rethrow;
      return decodeTasks(saved);
    }
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(tasks));
  }
}

// ---------- VIEWMODEL ----------

sealed class TasksState {
  const TasksState();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksLoaded extends TasksState {
  const TasksLoaded(this.tasks);
  final List<Task> tasks;
}

class TasksFailed extends TasksState {
  const TasksFailed(this.message);
  final String message;
}

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;
  TasksState _state = const TasksLoading();

  TasksState get state => _state;

  int get remaining => switch (_state) {
    TasksLoaded(:final tasks) => tasks.where((task) => !task.done).length,
    _ => 0,
  };

  Future<void> load() async {
    _state = const TasksLoading();
    notifyListeners();
    try {
      _state = TasksLoaded(await _repository.fetchTasks());
    } catch (_) {
      _state = const TasksFailed('Could not load tasks. Check your internet.');
    }
    notifyListeners();
  }

  void toggle(int id) {
    final current = _state;
    if (current is! TasksLoaded) return;
    _update([
      for (final task in current.tasks)
        if (task.id == id) task.copyWith(done: !task.done) else task,
    ]);
  }

  void add(String title) {
    final current = _state;
    if (current is! TasksLoaded) return;
    var nextId = 1;
    for (final task in current.tasks) {
      if (task.id >= nextId) nextId = task.id + 1;
    }
    _update([...current.tasks, Task(id: nextId, title: title)]);
  }

  void _update(List<Task> tasks) {
    _state = TasksLoaded(tasks);
    notifyListeners();
    _repository.saveTasks(tasks);
  }
}

// ---------- VIEW ----------

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key, required this.viewModel});

  final TasksViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: TasksScreen(viewModel: viewModel),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.viewModel});

  final TasksViewModel viewModel;

  Future<void> _openAddPage(BuildContext context) async {
    final title = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddTaskPage()),
    );
    if (title != null) viewModel.add(title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) =>
              Text('My Tasks (${viewModel.remaining} left)'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPage(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => switch (viewModel.state) {
          TasksLoading() => const Center(child: CircularProgressIndicator()),
          TasksFailed(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Text(message),
                FilledButton(
                  onPressed: viewModel.load,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          TasksLoaded(:final tasks) when tasks.isEmpty => const Center(
            child: Text('Nothing to do. Nice!'),
          ),
          TasksLoaded(:final tasks) => ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskTile(
              key: ValueKey(tasks[index].id),
              task: tasks[index],
              onToggle: () => viewModel.toggle(tasks[index].id),
            ),
          ),
        },
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: task.done ? colors.primaryContainer : Colors.transparent,
      // A ListTile draws its tap effects on the nearest Material. Without this
      // one, the container's color would hide them.
      child: Material(
        type: MaterialType.transparency,
        child: CheckboxListTile(
          title: Text(task.title),
          value: task.done,
          onChanged: (_) => onToggle(),
        ),
      ),
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
