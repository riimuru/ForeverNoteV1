import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_router.dart';
import './models/note.dart';
import './models/directory.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider(create: (context) => Notes()),
    ChangeNotifierProxyProvider<Notes, NoteModel>(
      create: (context) => NoteModel(),
      update: (context, note, item) {
        if (item == null) throw ArgumentError.notNull('item');
        item.note = note;
        return item;
      },
    ),
    Provider(create: (context) => Directories()),
    ChangeNotifierProxyProvider<Directories, DirectoryModel>(
      create: (context) => DirectoryModel(),
      update: (context, directory, dir) {
        if (dir == null) throw ArgumentError.notNull('item');
        dir.directory = directory;
        return dir;
      },
    )
  ], child: const App()));
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forever Note',
      home: MainRouter(),
    );
  }
}
