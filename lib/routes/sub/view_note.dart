import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../models/directory.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ViewNote extends StatelessWidget {
  final NoteStructure _v;
  const ViewNote(this._v);
  @override
  Widget build(BuildContext context) {
    var note = context.watch<NoteModel>();
    var directory = context.watch<DirectoryModel>();
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color(0x00000000),
          elevation: 0,
          title: const Text(
            "View Note",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: MediaQuery.of(context).size.height * 0.1,
              //alignment: Alignment.center,

              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: directory.directories.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: GestureDetector(
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Text(directory.directories[index].name)),
                          ),
                          onTap: () {
                            if (directory.directories[index].name == '/') {
                              const snackBar = SnackBar(
                                  content: Text(
                                      "You can't add or delete from / directory"),
                                  duration: Duration(seconds: 2));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              var notes = context.read<NoteModel>();
                              if (_v.directory ==
                                  directory.directories[index].name) {
                                note.modify(NoteStructure(
                                  id: notes.noteIdByTitle(_v.title),
                                  title: _v.title,
                                  content: _v.content,
                                  isTitleEmpty: false,
                                  directory: '/',
                                ));
                                final snackBar = SnackBar(
                                  content: Text(
                                      "${_v.title} was removed from the ${directory.directories[index].name} directory"),
                                  duration: const Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                              } else {
                                note.modify(NoteStructure(
                                  id: notes.noteIdByTitle(_v.title),
                                  title: _v.title,
                                  content: _v.content,
                                  isTitleEmpty: false,
                                  directory: directory.directories[index].name,
                                ));
                                final snackBar = SnackBar(
                                  content: Text(
                                      "${_v.title} was added to the ${directory.directories[index].name} directory"),
                                  duration: const Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                              }
                            }
                          },
                          // child: ListTile(
                          // title: Text(directory.directories[index].name),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          //onPressed: () {}
                        ),
                      )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Text(_v.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      inherit: false,
                      color: Colors.black,
                      //TODO Change the font
                      fontSize: 30,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: const Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 10.0,
                  endIndent: 10.0,
                )),
            //TODO Make the view in such a way that the title remains on top and content scrolls.
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 30.0),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Text(_v.content,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      inherit: false,
                      color: Colors.black,
                      //TODO Change the font
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            )
          ],
        )));
  }
}
