import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook_answers/w11.dart';
import 'package:flutter_test/flutter_test.dart';

class FailingRepository implements NotesRepository {
  @override
  Future<List<Note>> getNotes() async => throw Exception('down');

  @override
  Future<void> addNote(String text) async {}
}

void main() {
  test('1 repository stores notes with ids', () async {
    final repository = InMemoryNotesRepository();
    await repository.addNote('A');
    await repository.addNote('B');
    final notes = await repository.getNotes();
    expect(notes.map((n) => n.text), ['A', 'B']);
    expect(notes.last.id, 2);
  });

  test('2 ViewModel load notifies and finishes', () async {
    final viewModel = NotesViewModel(InMemoryNotesRepository());
    final loadingSeen = <bool>[];
    viewModel.addListener(() => loadingSeen.add(viewModel.isLoading));
    await viewModel.load();
    expect(loadingSeen, [true, false]);
    expect(viewModel.notes, isEmpty);
    expect(viewModel.error, isNull);
  });

  test('2 ViewModel works with any repository, and reports errors', () async {
    final viewModel = NotesViewModel(FailingRepository());
    await viewModel.load();
    expect(viewModel.error, 'Could not load notes');
    expect(viewModel.isLoading, isFalse);
  });

  test('2 ViewModel add trims, and ignores blank text', () async {
    final viewModel = NotesViewModel(InMemoryNotesRepository());
    await viewModel.add('   ');
    expect(viewModel.notes, isEmpty);
    await viewModel.add('  Hello  ');
    expect(viewModel.notes.single.text, 'Hello');
  });

  testWidgets('3 View draws what the ViewModel holds', (tester) async {
    final viewModel = NotesViewModel(InMemoryNotesRepository());
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: NotesView(viewModel: viewModel))),
    );
    await viewModel.add('Hello');
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('3 View shows the error', (tester) async {
    final viewModel = NotesViewModel(FailingRepository());
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: NotesView(viewModel: viewModel))),
    );
    await viewModel.load();
    await tester.pump();
    expect(find.text('Could not load notes'), findsOneWidget);
  });
}
