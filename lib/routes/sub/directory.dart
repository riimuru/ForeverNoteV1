import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/directory.dart';
import '../../models/note.dart';

class DirectoryWig extends StatelessWidget {
  String name = '';

  @override
  Widget build(BuildContext context){
    var directory = context.watch<DirectoryModel>();
    var note = context.watch<NoteModel>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        title: const Text(
          "Add Directory",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextField(
                maxLength: 20,
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Directory Name',
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
              )
            ),
            //TODO add a list of notes with checkboxes leading
            Container(
              padding: const EdgeInsets.all(0),
              child: ElevatedButton(
                onPressed: () {
                    var directories = context.read<DirectoryModel>();
                    if(name == "/"){
                      final snackBar = SnackBar(
                        content: Text("Can't make two root directories"),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else{
                    directories.add(
                      DirectoryStructure(
                        id: directory.directories.length,
                        name: name.isEmpty ? 'Directory #${directory.nullDirCount + 1}' : name,
                        isNameEmpty: name.isEmpty,
                      ),
                    );
                    Navigator.pop(context);
                    }
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
        )
      )
    );
  }
}