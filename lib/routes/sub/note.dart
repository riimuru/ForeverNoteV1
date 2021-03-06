import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';

import '../../models/note.dart';

class Note extends StatelessWidget {
  final NoteStructure? noteStruct;
  final Database? database;
  final String type;
  Note({this.noteStruct, this.database, required this.type});
  String title = "";
  String content = "";

  @override
  Widget build(BuildContext context) {
    var note = context.watch<NoteModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        title: Text(
          "Edit Note",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 20,
                initialValue: noteStruct == null ? '' : noteStruct?.title,
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  fillColor: Colors.yellow,
                  hintText: 'Title',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Text(
                "Content",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(
              height: 30 * 10.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  maxLines: 30,
                  initialValue: noteStruct == null ? '' : noteStruct?.content,
                  onChanged: (value) {
                    content = value;
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.yellow,
                    hintText: 'Note Content',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusColor: Colors.red,
                    filled: true,
                  ),
                  scrollPhysics: const BouncingScrollPhysics(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(305, 20, 0, 0),
              child: ElevatedButton(
                onPressed: () async {
                  var randNum = Random().nextInt(100000);
                  var notes = context.read<NoteModel>();
                  if (noteStruct == null) {
                    await database!.transaction((txn) async {
                      await txn.rawInsert(
                          "INSERT INTO notes (id, title, content, isTitleEmpty) VALUES (?, ?, ?, ?)",
                          [
                            randNum,
                            title.isEmpty
                                ? 'Note #${note.nullNoteCount + 1}'
                                : title,
                            "\t" + content,
                            title.isEmpty ? 1 : 0
                          ]);
                    });
                    notes.add(
                      NoteStructure(
                        id: randNum,
                        title: title.isEmpty
                            ? 'Note #${note.nullNoteCount + 1}'
                            : title,
                        content: "\t" + content,
                        isTitleEmpty: title.isEmpty,
                        type: type,
                      ),
                    );
                  } else {
                    var checkTitle = title.isEmpty ? noteStruct!.title : title;
                    await database!.transaction((txn) async {
                      await txn.rawUpdate(
                          'UPDATE notes SET title = ?, content = ?, isTitleEmpty = ? WHERE id = ?',
                          [
                            checkTitle,
                            content.isEmpty ? noteStruct!.content : content,
                            checkTitle.isEmpty ? 1 : 0,
                            noteStruct!.id
                          ]);
                    });
                    notes.modify(
                      NoteStructure(
                          id: noteStruct!.id,
                          title: checkTitle,
                          content:
                              content.isEmpty ? noteStruct!.content : content,
                          isTitleEmpty: title.isEmpty,
                          type: noteStruct!.type),
                    );
                  }
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5);
                      }
                      return Colors.red;
                    },
                  ),
                ),
                child: const Text("Done"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
