import 'package:flutter/material.dart';

class DownloadPopUp extends StatefulWidget {
  const DownloadPopUp({Key? key}) : super(key: key);

  @override
  _DownloadPopUpState createState() => _DownloadPopUpState();
}

class _DownloadPopUpState extends State<DownloadPopUp> {
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
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
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
                        "HELLO",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "DATA...",
                              softWrap: true,
                              style: TextStyle(fontSize: 12.0),
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
          )
        ],
      ),
    );
  }
}
