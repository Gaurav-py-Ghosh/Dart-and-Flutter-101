// ANSWERS for note 11. Try lib/workbook/w11.dart first.

import 'package:flutter/material.dart';

class Note {
  const Note({required this.id, required this.text});
  final int id;
  final String text;
}

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(String text);
}

class InMemoryNotesRepository implements NotesRepository {
  final List<Note> _notes = [];

  @override
  Future<List<Note>> getNotes() async => List.unmodifiable(_notes);

  @override
  Future<void> addNote(String text) async {
    _notes.add(Note(id: _notes.length + 1, text: text));
  }
}

class NotesViewModel extends ChangeNotifier {
  NotesViewModel(this._repository);
  final NotesRepository _repository;

  List<Note> _notes = const [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notes = await _repository.getNotes();
    } catch (_) {
      _error = 'Could not load notes';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> add(String text) async {
    if (text.trim().isEmpty) return;
    await _repository.addNote(text.trim());
    await load();
  }
}

class NotesView extends StatelessWidget {
  const NotesView({super.key, required this.viewModel});
  final NotesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const CircularProgressIndicator();
        }
        final error = viewModel.error;
        if (error != null) return Text(error);
        return Column(
          children: [for (final note in viewModel.notes) Text(note.text)],
        );
      },
    );
  }
}
