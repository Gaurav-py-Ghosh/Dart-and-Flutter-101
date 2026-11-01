// MY TASKS, finished stage from note 09: shared state with Provider.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage09.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyTasksApp());

class Task {
  const Task({required this.id, required this.title, this.done = false});

  final int id;
  final String title;
  final bool done;

  Task copyWith({bool? done}) =>
      Task(id: id, title: title, done: done ?? this.done);
}

class TaskStore extends ChangeNotifier {
  List<Task> _tasks = const [
    Task(id: 1, title: 'Learn widgets', done: true),
    Task(id: 2, title: 'Build a layout'),
    Task(id: 3, title: 'Pass the interview'),
  ];

  List<Task> get tasks => _tasks;
  int get remaining => _tasks.where((task) => !task.done).length;

  void toggle(int id) {
    _tasks = [
      for (final task in _tasks)
        if (task.id == id) task.copyWith(done: !task.done) else task,
    ];
    notifyListeners();
  }

  void add(String title) {
    _tasks = [..._tasks, Task(id: _tasks.length + 1, title: title)];
    notifyListeners();
  }
}

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStore(),
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
    final tasks = context.watch<TaskStore>().tasks;
    return Scaffold(
      appBar: AppBar(title: const RemainingTitle()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPage(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) =>
            TaskTile(key: ValueKey(tasks[index].id), task: tasks[index]),
      ),
    );
  }
}

class RemainingTitle extends StatelessWidget {
  const RemainingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final remaining = context.select<TaskStore, int>((s) => s.remaining);
    return Text('My Tasks ($remaining left)');
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.done,
        onChanged: (_) => context.read<TaskStore>().toggle(task.id),
      ),
      title: Text(task.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TaskDetailsPage(taskId: task.id)),
      ),
    );
  }
}

// This page reads the store too. So toggling here also updates the list.
class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    final task = store.tasks.firstWhere((task) => task.id == taskId);
    return Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: Center(
        child: SwitchListTile(
          title: Text(task.title),
          value: task.done,
          onChanged: (_) => store.toggle(task.id),
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
