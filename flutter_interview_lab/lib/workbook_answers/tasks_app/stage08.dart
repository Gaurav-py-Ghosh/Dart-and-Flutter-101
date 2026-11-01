// MY TASKS, finished stage from note 08: a validated form and a second screen.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage08.dart

import 'package:flutter/material.dart';

void main() => runApp(const MyTasksApp());

class Task {
  const Task({required this.id, required this.title, this.done = false});

  final int id;
  final String title;
  final bool done;

  Task copyWith({bool? done}) =>
      Task(id: id, title: title, done: done ?? this.done);
}

const sampleTasks = [
  Task(id: 1, title: 'Learn widgets', done: true),
  Task(id: 2, title: 'Build a layout'),
  Task(id: 3, title: 'Pass the interview'),
];

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const TasksScreen(),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = sampleTasks;

  void _toggle(int id) {
    setState(() {
      _tasks = [
        for (final task in _tasks)
          if (task.id == id) task.copyWith(done: !task.done) else task,
      ];
    });
  }

  Future<void> _openAddPage() async {
    final title = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddTaskPage()),
    );
    if (title == null || !mounted) return;
    setState(() {
      _tasks = [..._tasks, Task(id: _tasks.length + 1, title: title)];
    });
  }

  void _openDetails(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _tasks.where((task) => !task.done).length;
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks ($remaining left)')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPage,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return TaskTile(
            key: ValueKey(task.id),
            task: task,
            onToggle: () => _toggle(task.id),
            onOpen: () => _openDetails(task),
          );
        },
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onOpen,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
      title: Text(task.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onOpen,
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: Center(
        child: Text('${task.title}: ${task.done ? 'finished' : 'not finished'}'),
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
