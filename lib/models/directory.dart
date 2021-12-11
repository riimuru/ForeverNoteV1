import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'note.dart';

class DirectoryModel extends ChangeNotifier {
  late Directories _directory;
  var nullDirCounter = 0;

  List<DirectoryStructure> _directories = [
    DirectoryStructure(id: 1, name: '/', isNameEmpty: false)
  ];

  Directories get directory => _directory;

  set directory(Directories dir) {
    _directory = dir;
    notifyListeners();
  }

  int get nullDirCount => nullDirCounter;

  List<DirectoryStructure> get directories => [..._directories];

  set directoriesL(List<DirectoryStructure> l) => _directories += l;

  void add(DirectoryStructure dir) {
    _directories.add(dir);
    if (dir.isNameEmpty) {
      nullDirCounter++;
    }
    notifyListeners();
  }

  void removeDir(DirectoryStructure dir) {
    _directories.removeWhere((element) => element.id == dir.id);
    notifyListeners();
  }
}

class Directories {
  static List<DirectoryStructure> directories = [
    DirectoryStructure(id: 1, name: '/', isNameEmpty: false)
  ];

  DirectoryStructure getById(int id) => DirectoryStructure(
        id: id,
        name: directories[id % directories.length].name,
        files: directories[id % directories.length].files,
        isNameEmpty: directories[id % directories.length].isNameEmpty,
      );

  DirectoryStructure getByPosition(int position) {
    return getById(position);
  }
}

class DirectoryStructure {
  //TODO add recursive directories
  final int id;
  final String name;
  final List<NoteStructure>? files;
  final bool isNameEmpty;

  DirectoryStructure(
      {required this.id,
      required this.name,
      this.files,
      required this.isNameEmpty});

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) =>
      other is DirectoryStructure && other.id == id;
}
