import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

import '../services/database_helper.dart';
import '../models/downloads.dart';
import '../models/history.dart';
import '../models/note.dart';

class WarningPopUp2 extends StatefulWidget {
  String warningInfo;
  BuildContext context;
  DownloadModel d;
  NoteModel n;
  HistoryModel h;
  DatabaseHelper db;

  WarningPopUp2(
      this.context, this.d, this.n, this.h, this.db, this.warningInfo);

  @override
  _WarningPopUp2State createState() => _WarningPopUp2State(
      this.context, this.d, this.n, this.h, this.db, this.warningInfo);
}

class _WarningPopUp2State extends State<WarningPopUp2> {
  String warningInfo;
  BuildContext context;
  DownloadModel d;
  NoteModel n;
  HistoryModel h;
  DatabaseHelper db;

  _WarningPopUp2State(
      this.context, this.d, this.n, this.h, this.db, this.warningInfo);
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
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                padding: const EdgeInsets.all(5.0),
                child: const Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 20.0,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Warning",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              warningInfo,
                              softWrap: true,
                              style: const TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
              ElevatedButton(
                onPressed: () {
                  d.removeAll(context);
                  n.removeAll(context);
                  h.removeAll(context);

                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleLightTheme();

                  Navigator.pop(context);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "No",
                  style: TextStyle(
                    fontSize: 15,
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
