import 'package:flutter/cupertino.dart';

class HistoryModel extends ChangeNotifier {
  late History _history;

  final List<HistoryStructure> _histories = [];
  var nullNoteCounter = 0;

  History get history => _history;

  set note(History note) {
    _history = note;
    notifyListeners();
  }

  List<HistoryStructure> get items => [..._histories];

  int get nullNoteCount => nullNoteCounter;

  int get itemsCount => _histories.length;

  void add(HistoryStructure note) {
    _histories.add(note);
    if (note.url.isEmpty) {
      nullNoteCounter++;
    }
    notifyListeners();
  }

  void removeNote(HistoryStructure note) {
    _histories.removeWhere((element) => element.id == note.id);
    notifyListeners();
  }
}

class History {
  static List<HistoryStructure> notes = [];
}

class HistoryStructure {
  final int id;
  final String favicon;
  final String host;
  final String url;

  HistoryStructure({
    required this.id,
    required this.favicon,
    required this.host,
    required this.url,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is HistoryStructure && other.id == id;
}
