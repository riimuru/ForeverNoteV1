import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/downloads.dart';

class DownloadPopUp extends StatefulWidget {
  int id;
  DownloadTask details;
  String? favicon;
  BuildContext context;
  DownloadModel download;

  DownloadPopUp(
      this.id, this.details, this.favicon, this.download, this.context);

  @override
  _DownloadPopUpState createState() => _DownloadPopUpState(
        this.id,
        this.details,
        this.favicon,
        this.download,
        this.context,
      );
}

class _DownloadPopUpState extends State<DownloadPopUp> {
  int id;
  DownloadTask details;
  String? favicon;
  BuildContext context;
  DownloadModel download;

  _DownloadPopUpState(
      this.id, this.details, this.favicon, this.download, this.context);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                padding: const EdgeInsets.all(5.0),
                child: (favicon != null)
                    ? Container(
                        width: 25,
                        height: 25,
                        child: Image.network(
                          favicon!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 25.0,
                      ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Uri.parse(details.url).host,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "TaskID: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        details.taskId,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "File Name: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        Uri.parse(details.url)
                            .queryParametersAll[
                                "response-content-disposition"]![0]
                            .split("=")[1]
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Saved Dir: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        details.savedDir,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Size: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Unkown",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Progress: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        details.progress.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Authority: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        Uri.parse(details.url).authority.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "Date Time: ",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(details.timeCreated)
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                download.add(
                                  DownloadStructure(
                                    id: id,
                                    fileName: Uri.parse(details.url)
                                        .queryParametersAll[
                                            "response-content-disposition"]![0]
                                        .split("=")[1]
                                        .toString(),
                                    favicon: favicon!,
                                    host: Uri.parse(details.url).host,
                                    url: details.url,
                                    timeStamp:
                                        DateTime.fromMillisecondsSinceEpoch(
                                                details.timeCreated)
                                            .toString(),
                                  ),
                                  details.taskId,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text("Download")),
                          const SizedBox(
                            width: 30.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FlutterDownloader.cancel(taskId: details.taskId);
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
