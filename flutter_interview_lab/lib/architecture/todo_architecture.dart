// A small, complete app in the layers the Flutter team recommends:
//   View -> ViewModel -> Repository -> API
// Data flows down, and events flow up.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// ---------- MODEL: plain, immutable data ----------
class Todo {
  final int id;
  final String title;
  final bool done;

  const Todo({required this.id, required this.title, this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    done: json['completed'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': done,
  };

  Todo copyWith({bool? done}) =>
      Todo(id: id, title: title, done: done ?? this.done);
}

// ---------- REPOSITORY: the only door to the data ----------
// The rest of the app knows this abstract class, not how the data arrives.
abstract class TodoRepository {
  Future<List<Todo>> fetchTodos();
}

class ApiTodoRepository implements TodoRepository {
  ApiTodoRepository(this._client);
  final http.Client _client;

  @override
  Future<List<Todo>> fetchTodos() async {
    final response = await _client.get(Uri.parse('https://example.test/todos'));
    if (response.statusCode != 200) {
      throw Exception('Server replied ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => Todo.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

// A pretend server, so that this lab works with no internet.
// Set failNextCall to true to watch the error screen.
http.Client fakeServer({required bool Function() shouldFail}) {
  return MockClient((request) async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldFail()) return http.Response('Oops', 500);
    return http.Response(
      jsonEncode([
        {'id': 1, 'title': 'Learn widgets', 'completed': true},
        {'id': 2, 'title': 'Learn state management', 'completed': false},
        {'id': 3, 'title': 'Pass the interview', 'completed': false},
      ]),
      200,
    );
  });
}

// ---------- VIEWMODEL: screen state and logic, with no widgets ----------
sealed class TodoState {
  const TodoState();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoLoaded extends TodoState {
  const TodoLoaded(this.todos);
  final List<Todo> todos;
}

class TodoError extends TodoState {
  const TodoError(this.message);
  final String message;
}

class TodoViewModel extends ChangeNotifier {
  TodoViewModel(this._repository);
  final TodoRepository _repository;

  TodoState _state = const TodoLoading();
  TodoState get state => _state;

  Future<void> load() async {
    _state = const TodoLoading();
    notifyListeners();
    try {
      _state = TodoLoaded(await _repository.fetchTodos());
    } catch (e) {
      _state = TodoError(e.toString());
    }
    notifyListeners();
  }

  void toggle(int id) {
    final current = _state;
    if (current is! TodoLoaded) return;
    _state = TodoLoaded([
      for (final todo in current.todos)
        if (todo.id == id) todo.copyWith(done: !todo.done) else todo,
    ]);
    notifyListeners();
  }
}

// ---------- VIEW: draws the state and passes taps up ----------
class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key, required this.viewModel});
  final TodoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => switch (viewModel.state) {
        TodoLoading() => const Center(child: CircularProgressIndicator()),
        TodoError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              TextButton(onPressed: viewModel.load, child: const Text('Retry')),
            ],
          ),
        ),
        TodoLoaded(:final todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return CheckboxListTile(
              key: ValueKey(todo.id),
              title: Text(todo.title),
              value: todo.done,
              onChanged: (_) => viewModel.toggle(todo.id),
            );
          },
        ),
      },
    );
  }
}
