import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../services/database_helper.dart';
import '../widgets/warning_popup.dart';

class DownloadModel extends ChangeNotifier {
  late Download _download;

  final List<DownloadStructure> _downloads = [];
  var nullNoteCounter = 0;

  Download get download => _download;

  set download(Download download) {
    _download = download;
    notifyListeners();
  }

  List<DownloadStructure> get items => [..._downloads];

  int get itemsCount => _downloads.length;

  void add(DownloadStructure download, String taskId) async {
    _downloads.add(download);
    await DatabaseHelper.db.addDownload(download);

    if (download.url.isEmpty) {
      nullNoteCounter++;
    }
    FlutterDownloader.resume(taskId: taskId);
    notifyListeners();
  }

  void removeDownload(DownloadStructure download) async {
    _downloads.removeWhere((element) => element.id == download.id);
    await DatabaseHelper.db.removeDownloadAt(download.id);
    notifyListeners();
  }

  void addList(List<DownloadStructure> histories) {
    _downloads.addAll(histories);
    notifyListeners();
  }

  Future<dynamic> removeAll(BuildContext context) async {
    _downloads.clear();
    await DatabaseHelper.db.removeAllDownloads();
    notifyListeners();
  }
}

class Download {
  static List<DownloadStructure> downloads = [];
}

class DownloadStructure {
  final int id;
  final String fileName;
  final String favicon;
  final String host;
  final String url;
  final String timeStamp;

  DownloadStructure({
    required this.id,
    required this.fileName,
    required this.favicon,
    required this.host,
    required this.url,
    required this.timeStamp,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) =>
      other is DownloadStructure && other.id == id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'favicon': favicon,
      'host': host,
      'url': url,
      'timeStamp': timeStamp,
    };
  }
}
