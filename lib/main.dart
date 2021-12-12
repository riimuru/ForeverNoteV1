import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_router.dart';
import './models/note.dart';
import './models/history.dart';
import './provider/browser_provider.dart';
import './models/directory.dart';
import './models/downloads.dart';
import 'provider/theme_provider.dart';
import './utils/constants.dart';
import './utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug: true // set false to disable printing logs to console
      );

  await Permission.storage.request();

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  prefs.then((value) => runApp(
        MultiProvider(
          providers: [
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
            ),
            Provider(create: (context) => History()),
            ChangeNotifierProxyProvider<History, HistoryModel>(
              create: (context) => HistoryModel(),
              update: (context, history, item) {
                if (item == null) throw ArgumentError.notNull('item');
                item.history = history;
                return item;
              },
            ),
            ChangeNotifierProvider(create: (context) {
              bool? isDesktopMode = value.getBool("isDesktopMode");
              return BrowserProvider(
                  (isDesktopMode == null) ? false : isDesktopMode);
            }),
            Provider(create: (context) => Download()),
            ChangeNotifierProxyProvider<Download, DownloadModel>(
              create: (context) => DownloadModel(),
              update: (context, download, item) {
                if (item == null) throw ArgumentError.notNull('item');
                item.download = download;
                return item;
              },
            ),
            ChangeNotifierProvider(create: (context) {
              String? theme = value.getString(Constant.APP_THEME);
              return (theme == null ||
                      theme.isEmpty ||
                      theme == Constant.SYSTEM_DEFAULT)
                  ? ThemeProvider(ThemeMode.dark)
                  : ThemeProvider(theme == Constant.DARK
                      ? ThemeMode.dark
                      : ThemeMode.light);
            }),
          ],
          child: const App(),
        ),
      ));
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forever Note',
      home: const MainRouter(),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
    );
  }
}
