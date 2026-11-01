// Run with:  flutter test
// This shows the three kinds of test against the MVVM todo feature.

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/architecture/todo_architecture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

// A FAKE is a small working stand-in. The Flutter team recommends these.
class FakeTodoRepository implements TodoRepository {
  FakeTodoRepository({this.shouldFail = false});
  final bool shouldFail;

  @override
  Future<List<Todo>> fetchTodos() async {
    if (shouldFail) throw Exception('No internet');
    return const [Todo(id: 1, title: 'Write tests')];
  }
}

// A MOCK records calls, so you can check how it was used.
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('Model', () {
    test('fromJson reads the fields', () {
      final todo = Todo.fromJson({'id': 1, 'title': 'A', 'completed': true});
      expect(todo.id, 1);
      expect(todo.done, isTrue);
    });

    test('a missing completed field means not done', () {
      expect(Todo.fromJson({'id': 1, 'title': 'A'}).done, isFalse);
    });

    test('copyWith does not change the original', () {
      const original = Todo(id: 1, title: 'A');
      final changed = original.copyWith(done: true);
      expect(original.done, isFalse);
      expect(changed.done, isTrue);
    });
  });

  group('Repository', () {
    test('turns a 200 reply into todos', () async {
      final client = MockClient(
        (_) async => http.Response('[{"id":1,"title":"A"}]', 200),
      );
      final todos = await ApiTodoRepository(client).fetchTodos();
      expect(todos.single.title, 'A');
    });

    test('throws on a 500 reply', () {
      final client = MockClient((_) async => http.Response('Oops', 500));
      expect(ApiTodoRepository(client).fetchTodos(), throwsException);
    });
  });

  group('ViewModel', () {
    test('starts loading, then has data', () async {
      final viewModel = TodoViewModel(FakeTodoRepository());
      expect(viewModel.state, isA<TodoLoading>());
      await viewModel.load();
      expect(viewModel.state, isA<TodoLoaded>());
    });

    test('shows an error when the repository fails', () async {
      final viewModel = TodoViewModel(FakeTodoRepository(shouldFail: true));
      await viewModel.load();
      expect(viewModel.state, isA<TodoError>());
    });

    test('toggle flips the done flag and notifies listeners', () async {
      final viewModel = TodoViewModel(FakeTodoRepository());
      await viewModel.load();
      var notified = 0;
      viewModel.addListener(() => notified++);
      viewModel.toggle(1);
      expect((viewModel.state as TodoLoaded).todos.single.done, isTrue);
      expect(notified, 1);
    });

    test('mock: load calls the repository exactly once', () async {
      final repository = MockTodoRepository();
      when(repository.fetchTodos).thenAnswer((_) async => const []);
      await TodoViewModel(repository).load();
      verify(repository.fetchTodos).called(1);
    });
  });

  group('Widget', () {
    Future<void> pumpScreen(WidgetTester tester, TodoRepository repo) async {
      final viewModel = TodoViewModel(repo);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TodoScreen(viewModel: viewModel)),
        ),
      );
      await viewModel.load();
      await tester.pump();
    }

    testWidgets('shows todos and toggles a checkbox', (tester) async {
      await pumpScreen(tester, FakeTodoRepository());
      expect(find.text('Write tests'), findsOneWidget);

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();

      final tile = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(tile.value, isTrue);
    });

    testWidgets('shows the error and a retry button', (tester) async {
      await pumpScreen(tester, FakeTodoRepository(shouldFail: true));
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
