import 'package:forever_note/models/downloads.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';
import '../models/history.dart';
import '../models/downloads.dart';

class DatabaseHelper {
  DatabaseHelper();
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await instDatabase();
    return _database;
  }

  Future<Database> startDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'note_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS browser_history(id INTEGER PRIMERY KEY, favicon TEXT, host TEXT, url TEXT, timeStamp TEXT)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS browser_downloads(id INTEGER PRIMERY KEY, fileName TEXT, favicon TEXT, host TEXT, url TEXT, timeStamp TEXT)',
        );
        await db.execute(
            'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMERY KEY, title TEXT, content TEXT, isTitleEmpty INTEGER, directory TEXT)');
      },
      version: 1,
    );
  }

  Future<Database> instDatabase() async {
    _database = await startDatabase();
    return _database!;
  }

  Future<List<HistoryStructure>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> map =
        await db!.rawQuery('SELECT * FROM browser_history');
    return List.generate(map.length, (i) {
      return HistoryStructure(
        id: map[i]['id'],
        favicon: map[i]['favicon'],
        host: map[i]['host'],
        url: map[i]['url'],
        timeStamp: map[i]['timeStamp'],
      );
    });
  }

  Future<List<DownloadStructure>> getDownloads() async {
    final db = await database;
    final List<Map<String, dynamic>> map =
        await db!.rawQuery('SELECT * FROM browser_downloads');
    return List.generate(map.length, (i) {
      return DownloadStructure(
        id: map[i]['id'],
        fileName: map[i]['fileName'],
        favicon: map[i]['favicon'],
        host: map[i]['host'],
        url: map[i]['url'],
        timeStamp: map[i]['timeStamp'],
      );
    });
  }

  addHistory(HistoryStructure history) async {
    final db = await database;
    await db!.insert(
      'browser_history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeAllHistory() async {
    final db = await database;
    await db!.rawQuery("DELETE FROM browser_history");
  }

  removeHistoryAt(int id) async {
    final db = await database;
    await db!.rawQuery("DELETE FROM browser_history WHERE id=$id");
  }

  addDownload(DownloadStructure download) async {
    final db = await database;
    await db!.insert(
      'browser_downloads',
      download.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeAllDownloads() async {
    final db = await database;
    await db!.rawQuery("DELETE FROM browser_downloads");
  }

  removeAllNotes() async {
    final db = await database;
    await db!.rawQuery("DELETE FROM notes");
  }

  removeDownloadAt(int id) async {
    final db = await database;
    await db!.rawQuery("DELETE FROM browser_downloads WHERE id=$id");
  }
}
