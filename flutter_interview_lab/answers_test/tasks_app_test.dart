// This is also the finished answer for note 12: tests for My Tasks.
// Run:  flutter test answers_test/tasks_app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage06.dart'
    as s06;
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage07.dart'
    as s07;
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage08.dart'
    as s08;
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage09.dart'
    as s09;
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage10.dart'
    as s10;
import 'package:flutter_interview_lab/workbook_answers/tasks_app/stage11.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A fake repository: a small working stand-in with no network.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({this.shouldFail = false});

  final bool shouldFail;
  List<Task>? saved;

  @override
  Future<List<Task>> fetchTasks() async {
    if (shouldFail) throw Exception('No internet');
    return const [
      Task(id: 1, title: 'First'),
      Task(id: 2, title: 'Second', done: true),
    ];
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async => saved = tasks;
}

void main() {
  group('Stage 6 to 10 smoke tests', () {
    testWidgets('06 shows the tasks', (tester) async {
      await tester.pumpWidget(const s06.MyTasksApp());
      expect(find.text('Learn widgets'), findsOneWidget);
    });

    testWidgets('07 toggles and adds', (tester) async {
      await tester.pumpWidget(const s07.MyTasksApp());
      expect(find.text('My Tasks (2 left)'), findsOneWidget);
      await tester.tap(find.text('Build a layout'));
      await tester.pump();
      expect(find.text('My Tasks (1 left)'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'New one');
      await tester.tap(find.text('Add'));
      await tester.pump();
      expect(find.text('New one'), findsOneWidget);
      expect(find.text('My Tasks (2 left)'), findsOneWidget);
    });

    testWidgets('08 adds through a validated form', (tester) async {
      await tester.pumpWidget(const s08.MyTasksApp());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Please enter a title'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'Buy milk');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Buy milk'), findsOneWidget);
      await tester.tap(find.text('Buy milk'));
      await tester.pumpAndSettle();
      expect(find.text('Buy milk: not finished'), findsOneWidget);
    });

    testWidgets('09 shares state between screens', (tester) async {
      await tester.pumpWidget(const s09.MyTasksApp());
      await tester.tap(find.text('Build a layout'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('My Tasks (1 left)'), findsOneWidget);
    });

    testWidgets('10 loads, then uses the offline copy', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final working = MockClient(
        (_) async => http.Response('[{"id":1,"title":"From API"}]', 200),
      );
      final store = s10.TaskStore(working);
      await tester.runAsync(store.load);
      expect(store.tasks.single.title, 'From API');

      final broken = MockClient((_) async => http.Response('Oops', 500));
      final offlineStore = s10.TaskStore(broken);
      await tester.runAsync(offlineStore.load);
      expect(offlineStore.tasks.single.title, 'From API');
      expect(offlineStore.error, isNull);
    });

    testWidgets('10 shows an error with no offline copy', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final broken = MockClient((_) async => http.Response('Oops', 500));
      final store = s10.TaskStore(broken);
      await tester.runAsync(store.load);
      expect(store.error, isNotNull);
    });
  });

  group('Model', () {
    test('fromJson reads the fields', () {
      final task = Task.fromJson({'id': 1, 'title': 'A', 'completed': true});
      expect(task.title, 'A');
      expect(task.done, isTrue);
    });

    test('copyWith does not change the original', () {
      const original = Task(id: 1, title: 'A');
      expect(original.copyWith(done: true).done, isTrue);
      expect(original.done, isFalse);
    });
  });

  group('Validation', () {
    test('validateTitle', () {
      expect(validateTitle(''), 'Please enter a title');
      expect(validateTitle('ab'), 'Use at least 3 characters');
      expect(validateTitle('abc'), isNull);
    });
  });

  group('ViewModel', () {
    test('load goes from loading to loaded', () async {
      final viewModel = TasksViewModel(FakeTaskRepository());
      expect(viewModel.state, isA<TasksLoading>());
      await viewModel.load();
      expect(viewModel.state, isA<TasksLoaded>());
      expect(viewModel.remaining, 1);
    });

    test('load shows failure when the repository fails', () async {
      final viewModel = TasksViewModel(FakeTaskRepository(shouldFail: true));
      await viewModel.load();
      expect(viewModel.state, isA<TasksFailed>());
    });

    test('toggle changes the task, notifies and saves', () async {
      final repository = FakeTaskRepository();
      final viewModel = TasksViewModel(repository);
      await viewModel.load();
      var notified = 0;
      viewModel.addListener(() => notified++);

      viewModel.toggle(1);

      expect(viewModel.remaining, 0);
      expect(notified, 1);
      expect(repository.saved?.first.done, isTrue);
    });

    test('add gives the new task a fresh id', () async {
      final viewModel = TasksViewModel(FakeTaskRepository());
      await viewModel.load();
      viewModel.add('Third');
      final tasks = (viewModel.state as TasksLoaded).tasks;
      expect(tasks.last.id, 3);
    });
  });

  group('Screen', () {
    Future<TasksViewModel> pumpApp(
      WidgetTester tester,
      TaskRepository repository,
    ) async {
      final viewModel = TasksViewModel(repository);
      await tester.pumpWidget(MyTasksApp(viewModel: viewModel));
      await viewModel.load();
      await tester.pump();
      return viewModel;
    }

    testWidgets('shows tasks, and tapping one updates the title', (
      tester,
    ) async {
      await pumpApp(tester, FakeTaskRepository());
      expect(find.text('First'), findsOneWidget);
      expect(find.text('My Tasks (1 left)'), findsOneWidget);
      await tester.tap(find.text('First'));
      await tester.pumpAndSettle();
      expect(find.text('My Tasks (0 left)'), findsOneWidget);
    });

    testWidgets('shows the error and a Retry button', (tester) async {
      await pumpApp(tester, FakeTaskRepository(shouldFail: true));
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('adds a task through the form', (tester) async {
      await pumpApp(tester, FakeTaskRepository());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Third');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Third'), findsOneWidget);
    });
  });
}
