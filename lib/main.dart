import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main_router.dart';
import './models/note.dart';
import './models/history.dart';
import './provider/browser_provider.dart';
import './models/directory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // set false to disable printing logs to console
      );
  await Permission.storage.request();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => Notes()),
        ChangeNotifierProxyProvider<Notes, NoteModel>(
          create: (context) {
            return NoteModel();
          },
          update: (context, note, item) {
            if (item == null) throw ArgumentError.notNull('item');
            item.note = note;
            return item;
          },
        ),
        Provider(create: (context) => Directories()),
        ChangeNotifierProxyProvider<Directories, DirectoryModel>(
          create: (context) {  
            return DirectoryModel();
          },
          update: (context, directory, dir) {
            if (dir == null) throw ArgumentError.notNull('item');
            dir.directory = directory;
            return dir;
          },
        ),
        Provider(create: (context) => History()),
        ChangeNotifierProxyProvider<History, HistoryModel>(
          create: (context) => HistoryModel(),
          update: (context, history, item) {
            if (item == null) throw ArgumentError.notNull('item');
            item.note = history;
            return item;
          },
        ),
        ChangeNotifierProvider(
          create: (context) =>
              BrowserProvider(false), // TODO: add local storage
        )
      ],
      child: const App(),
    ),
  );
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
