// MY TASKS, finished stage from note 07: the screen now has state.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage07.dart

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
  final _titleController = TextEditingController();
  List<Task> _tasks = sampleTasks;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggle(int id) {
    setState(() {
      _tasks = [
        for (final task in _tasks)
          if (task.id == id) task.copyWith(done: !task.done) else task,
      ];
    });
  }

  void _add() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _tasks = [..._tasks, Task(id: _tasks.length + 1, title: title)];
    });
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _tasks.where((task) => !task.done).length;
    return Scaffold(
      appBar: AppBar(title: Text('My Tasks ($remaining left)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'New task'),
                  ),
                ),
                FilledButton(onPressed: _add, child: const Text('Add')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskTile(
                  key: ValueKey(task.id),
                  task: task,
                  onToggle: () => _toggle(task.id),
                );
              },
            ),
          ),
        ],
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
    return CheckboxListTile(
      title: Text(task.title),
      value: task.done,
      onChanged: (_) => onToggle(),
    );
  }
}
