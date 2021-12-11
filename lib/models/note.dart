import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class NoteModel extends ChangeNotifier {
  late Notes _note;
  late Database database;
  List<NoteStructure> notes = [];

  Future<Database> startDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'note_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMERY KEY, title TEXT, content TEXT, isTitleEmpty INTEGER, directory TEXT)'
        );
      },
      version: 1,
    );
  }

  Future<Database> instDatabase() async {
    database = await startDatabase();
    return database;
  }

  // Future<List<NoteStructure>> getDatabase() async {
  //   final List<Map<String, dynamic>> map = await database.rawQuery('SELECT * FROM notes');
  //   return List.generate(map.length, (i) {
  //     return NoteStructure(
  //       id: map[i]['id'], 
  //       title: map[i]['title'], 
  //       content: map[i]['content'], 
  //       directory: map[i]['directory'],
  //       isTitleEmpty: map[i]['isTitleEmpty']);
  //   });
  // }

  // void setDatabase() async {
  //   notes = await getDatabase();
  // }

  var nullNoteCounter = 0;
  var noteNumber = 0;

  Notes get note => _note;

  set note(Notes note) {
    _note = note;
    notifyListeners();
  }


  List<NoteStructure> get items => [...notes];

  set itemsL(List<NoteStructure> l) => [...notes, ...l];

  int get nullNoteCount => nullNoteCounter;

  int get noteNumberCount => noteNumber;

  int get itemsCount => notes.length;

  int noteIdByTitle(String title) {
    return notes
        .elementAt(notes.indexWhere((element) => element.title == title))
        .id;
  }

  void add(NoteStructure note)async {
    notes.add(note);
    if (note.isTitleEmpty) {
      nullNoteCounter++;
    }
    noteNumber++;
    // var result = await database.transaction((txn) async {
    //   await txn.rawInsert(
    //     "INSERT INTO notes (id, title, content, isTitleEmpty, directory) VALUES (?, ?, ?, ?, ?)", 
    //     [note.id, note.title, note.content, note.isTitleEmpty ? 1 : 0, note.directory]
    //   );
    // });
    // print(result);
    notifyListeners();
  }

  void modify(NoteStructure note) async {
    removeNote(note);
    notes.add(note);
    // var result = await database.transaction((txn) async {
    //   await txn.rawUpdate('UPDATE notes SET title = ?, content = ?, isTitleEmpty = ?, directory = ? WHERE id = ?', [note.title, note.content, note.isTitleEmpty ? 1 : 0, note.directory, note.id]);
    // });
    // print(result);
    notifyListeners();
  }

  void removeNote(NoteStructure note) async {
    notes.removeWhere((element) => element.id == note.id);
    // var result = await database.transaction((txn) async {
    //   await txn.rawDelete('DELETE FROM notes WHERE id = ?', [note.id]);
    // });
    // print(result);
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
      directory: notes[id % notes.length].directory,
      type: notes[id % notes.length].type,
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
  final String? directory;
  final String? type;

  NoteStructure({
    required this.id,
    required this.title,
    required this.content,
    required this.isTitleEmpty,
    this.type,
    this.directory,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is NoteStructure && other.id == id;
}
