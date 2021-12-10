import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:forever_note/routes/note.dart';

class NoteModel extends ChangeNotifier {
  late Notes _note;

  final List<NoteStructure> _notes = [];
  var nullNoteCounter = 0;

  Notes get note => _note;

  set note(Notes note) {
    _note = note;
    notifyListeners();
  }

  List<NoteStructure> get items => [..._notes];

  int get nullNoteCount => nullNoteCounter;

  int get itemsCount => _notes.length;

  void add(NoteStructure note) {
    _notes.add(note);
    if(note.isTitleEmpty){
      nullNoteCounter++;
    }
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
      isTitleEmpty: notes[id % notes.length].isTitleEmpty
      );

  NoteStructure getByPosition(int position) {
    return getById(position);
  }
}

class NoteStructure {
  final int id;
  final String title;
  final String content;
  final bool isTitleEmpty;

  NoteStructure({
    required this.id,
    required this.title,
    required this.content,
    required this.isTitleEmpty,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is NoteStructure && other.id == id;
}
