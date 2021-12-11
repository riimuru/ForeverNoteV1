import 'package:flutter/material.dart';

class Logs extends StatefulWidget {
  List<String> logs = [];
  Logs(this.logs);

  @override
  _LogsState createState() => _LogsState(this.logs);
}

class _LogsState extends State<Logs> {
  List<String> logs = [];
  _LogsState(this.logs);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Console logs",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellowAccent[700],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: logs.length,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  tileColor: Colors.black87,
                  title: Text(
                    logs[index],
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )),
    );
  }
}
