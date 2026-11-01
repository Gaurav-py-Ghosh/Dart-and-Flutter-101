// NOTE 11 WORKBOOK. Build one feature in layers, from the bottom up.
// Check it:  flutter test workbook_test/w11_test.dart
// Answers are in lib/workbook_answers/w11.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';

/// The model and the repository's contract are finished for you.
class Note {
  const Note({required this.id, required this.text});
  final int id;
  final String text;
}

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(String text);
}

/// 1. REPOSITORY. Keep the notes in a private list. A new note's id is
/// the list's length + 1.
class InMemoryNotesRepository implements NotesRepository {
  @override
  Future<List<Note>> getNotes() => throw UnimplementedError();

  @override
  Future<void> addNote(String text) => throw UnimplementedError();
}

/// 2. VIEWMODEL. It receives the repository in its constructor. It has no
/// widgets in it.
/// load: set isLoading to true and clear the error, notify, get the notes.
/// If that fails, set error to 'Could not load notes'. Finally, set isLoading
/// to false and notify.
/// add: ignore empty or blank text. Otherwise add the trimmed text, then load.
class NotesViewModel extends ChangeNotifier {
  NotesViewModel(NotesRepository repository);

  List<Note> get notes => throw UnimplementedError();
  bool get isLoading => throw UnimplementedError();
  String? get error => throw UnimplementedError();

  Future<void> load() => throw UnimplementedError();
  Future<void> add(String text) => throw UnimplementedError();
}

/// 3. VIEW. Use ListenableBuilder.
/// Loading: CircularProgressIndicator. Error: Text(error).
/// Otherwise: a Column with a Text for each note.
class NotesView extends StatelessWidget {
  const NotesView({super.key, required this.viewModel});
  final NotesViewModel viewModel;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
