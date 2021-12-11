import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import '../widgets/warning_popup.dart';

class HistoryModel extends ChangeNotifier {
  late History _history;

  final List<HistoryStructure> _histories = [];
  var nullNoteCounter = 0;

  History get history => _history;

  set history(History history) {
    _history = history;
    notifyListeners();
  }

  List<HistoryStructure> get items => [..._histories];

  int get itemsCount => _histories.length;

  void add(HistoryStructure history) async {
    _histories.add(history);
    await DatabaseHelper.db.addHistory(history);

    if (history.url.isEmpty) {
      nullNoteCounter++;
    }
    notifyListeners();
  }

  void removeHistory(HistoryStructure history) async {
    _histories.removeWhere((element) => element.id == history.id);
    await DatabaseHelper.db.removeHistoryAt(history.id);
    notifyListeners();
  }

  void addList(List<HistoryStructure> histories) {
    _histories.addAll(histories);
    notifyListeners();
  }

  Future<dynamic> removeAll(BuildContext context) async {
    _histories.clear();
    await DatabaseHelper.db.removeAllHistory();
    notifyListeners();
  }
}

class History {
  static List<HistoryStructure> histories = [];
}

class HistoryStructure {
  final int id;
  final String favicon;
  final String host;
  final String url;
  final String timeStamp;

  HistoryStructure({
    required this.id,
    required this.favicon,
    required this.host,
    required this.url,
    required this.timeStamp,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is HistoryStructure && other.id == id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'favicon': favicon,
      'host': host,
      'url': url,
      'timeStamp': timeStamp,
    };
  }
}
