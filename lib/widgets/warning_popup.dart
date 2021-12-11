import 'package:flutter/material.dart';
import 'package:forever_note/models/history.dart';

class WarningPopUp extends StatefulWidget {
  String warningInfo;
  BuildContext context;
  HistoryModel obj;

  WarningPopUp(this.warningInfo, this.context, this.obj);

  @override
  _WarningPopUpState createState() =>
      _WarningPopUpState(this.warningInfo, this.context, this.obj);
}

class _WarningPopUpState extends State<WarningPopUp> {
  String warningInfo;
  BuildContext _;
  HistoryModel obj;

  _WarningPopUpState(this.warningInfo, this._, this.obj);
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
              const Padding(padding: EdgeInsets.symmetric(horizontal: 15.0)),
              ElevatedButton(
                onPressed: () {
                  obj.removeAll(context);
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
