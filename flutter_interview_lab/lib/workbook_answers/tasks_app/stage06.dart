// MY TASKS, finished stage from note 06: a static screen.
// Run:  flutter run -d windows -t lib/workbook_answers/tasks_app/stage06.dart

import 'package:flutter/material.dart';

void main() => runApp(const MyTasksApp());

class Task {
  const Task({required this.id, required this.title, this.done = false});

  final int id;
  final String title;
  final bool done;
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
      home: const TasksScreen(tasks: sampleTasks),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskTile(task: tasks[index]),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(task.done ? Icons.check_circle : Icons.circle_outlined),
          const SizedBox(width: 12),
          Expanded(child: Text(task.title)),
          Text(task.done ? 'Done' : 'To do'),
        ],
      ),
    );
  }
}
