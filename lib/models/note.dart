import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:forever_note/routes/sub/note.dart';

class NoteModel extends ChangeNotifier {
  late Notes _note;

  final List<NoteStructure> _notes = [];
  var nullNoteCounter = 0;
  var noteNumber = 0;

  Notes get note => _note;

  set note(Notes note) {
    _note = note;
    notifyListeners();
  }

  List<NoteStructure> get items => [..._notes];

  int get nullNoteCount => nullNoteCounter;

  int get noteNumberCount => noteNumber;

  int get itemsCount => _notes.length;

  int noteIdByTitle(String title) {
    return _notes.elementAt(_notes.indexWhere((element) => element.title == title)).id;
  }

  void add(NoteStructure note) {
    _notes.add(note);
    if (note.isTitleEmpty) {
      nullNoteCounter++;
    }
    noteNumber++;
    notifyListeners();
  }

  void modify(NoteStructure note){
    removeNote(note);
    _notes.add(note);
    notifyListeners();
  }

  void removeNote(NoteStructure note) {
    _notes.removeWhere((element) => element.id == note.id);
    notifyListeners();
  }
}

class Notes {
  static List<NoteStructure> notes = [];

  NoteStructure getById(int id) => NoteStructure(
      id: id,
      title: notes[id % notes.length].title,
      content: notes[id % notes.length].content,
      isTitleEmpty: notes[id % notes.length].isTitleEmpty,
      directory: notes[id % notes.length].directory);

  NoteStructure getByPosition(int position) {
    return getById(position);
  }
}

class NoteStructure {
  final int id;
  final String title;
  final String content;
  final bool isTitleEmpty;
  final String? directory;

  NoteStructure({
    required this.id,
    required this.title,
    required this.content,
    required this.isTitleEmpty,
    this.directory,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is NoteStructure && other.id == id;
}
