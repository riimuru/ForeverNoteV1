import 'package:flutter/material.dart';
import 'package:forever_note/services/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'sub/note.dart';
import 'sub/directory.dart';
import '../widgets/expandable_button.dart';
import '../../models/note.dart';
import '../../models/directory.dart';
import '../routes/sub/view_note.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  String dire = '/';
  String imp = '';
  late Database database;
  late Database database2;

  Future<Widget> _noteBuilder(
      String str, String str2, BuildContext context) async {
    var note = context.watch<NoteModel>();

    Future<Database> instDatabase() async {
      database = await DatabaseHelper.db.startDatabase();
      return database;
    }

    await instDatabase();

    Future<List<NoteStructure>> getDatabase() async {
      final List<Map<String, dynamic>> map =
          await database.rawQuery('SELECT * FROM notes');
      return List.generate(map.length, (i) {
        return NoteStructure(
            id: map[i]['id'],
            title: map[i]['title'],
            content: map[i]['content'],
            directory: map[i]['directory'],
            isTitleEmpty: map[i]['isTitleEmpty'] == 1 ? true : false);
      });
    }
    // this line was causing error
    // note.itemsL = await getDatabase();

    return ListView.builder(
        shrinkWrap: true,
        itemCount: note.items.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          print(str2);
          if (str == '/') {
            if (str2.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(note.items[index].title),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewNote(note.items[index], database))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Note(
                                  noteStruct: note.items[index],
                                  database: database)),
                        ),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () async {
                          await database.transaction((txn) async {
                            await txn.rawDelete(
                                'DELETE FROM notes WHERE id = ?',
                                [note.items[index].id]);
                          });
                          note.removeNote(note.items[index]);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                          splashRadius: 20.0,
                          onPressed: () {},
                          icon: Icon(
                            Icons.cloud,
                            color: Colors.blue[700],
                          )),
                    ],
                  ),
                  tileColor: Colors.amber,
                ),
              );
            } else if (note.items[index].title.contains(str2)) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(note.items[index].title),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewNote(note.items[index], database))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Note(
                                  noteStruct: note.items[index],
                                  database: database)),
                        ),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () async {
                          await database.transaction((txn) async {
                            await txn.rawDelete(
                                'DELETE FROM notes WHERE id = ?',
                                [note.items[index].id]);
                          });
                          note.removeNote(note.items[index]);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                          splashRadius: 20.0,
                          onPressed: () {},
                          icon: Icon(
                            Icons.cloud,
                            color: Colors.blue[700],
                          )),
                    ],
                  ),
                  tileColor: Colors.amber,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            if (note.items[index].directory == dire) {
              if (str2.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(note.items[index].title),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewNote(note.items[index], database))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          splashRadius: 20.0,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Note(
                                    noteStruct: note.items[index],
                                    database: database)),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          splashRadius: 20.0,
                          onPressed: () async {
                            await database.transaction((txn) async {
                              await txn.rawDelete(
                                  'DELETE FROM notes WHERE id = ?',
                                  [note.items[index].id]);
                            });
                            note.removeNote(note.items[index]);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            splashRadius: 20.0,
                            onPressed: () {},
                            icon: Icon(
                              Icons.cloud,
                              color: Colors.blue[700],
                            )),
                      ],
                    ),
                    tileColor: Colors.amber,
                  ),
                );
              } else if (note.items[index].title.contains(str2)) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(note.items[index].title),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewNote(note.items[index], database))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          splashRadius: 20.0,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Note(
                                    noteStruct: note.items[index],
                                    database: database)),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          splashRadius: 20.0,
                          onPressed: () async {
                            await database.transaction((txn) async {
                              await txn.rawDelete(
                                  'DELETE FROM notes WHERE id = ?',
                                  [note.items[index].id]);
                            });
                            note.removeNote(note.items[index]);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            splashRadius: 20.0,
                            onPressed: () {},
                            icon: Icon(
                              Icons.cloud,
                              color: Colors.blue[700],
                            )),
                      ],
                    ),
                    tileColor: Colors.amber,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            } else {
              return const SizedBox.shrink();
            }
          }
        });
  }

  Future<Widget> _directoryBuilder(DirectoryModel directory) async {
    Future<Database> startDatabase() async {
      return openDatabase(
        join(await getDatabasesPath(), 'directory_database.db'),
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS directories (id INTEGER PRIMERY KEY, name TEXT, isNameEmpty INTEGER)');
        },
        version: 1,
      );
    }

    Future<Database> instDatabase() async {
      database2 = await startDatabase();
      return database2;
    }

    await instDatabase();

    Future<List<DirectoryStructure>> getDatabase() async {
      final List<Map<String, dynamic>> map =
          await database2.rawQuery('SELECT * FROM directories');
      return List.generate(map.length, (i) {
        return DirectoryStructure(
          id: map[i]['id'],
          name: map[i]['name'],
          isNameEmpty: map[i]['isNameEmpty'] == 1 ? true : false,
        );
      });
    }

    //directory.directoriesL = await getDatabase();

    return ListView.builder(
      itemCount: directory.directories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(2),
        child: ListTile(
            //TODO add open and close feature
            leading: const Icon(Icons.folder),
            title: Text(directory.directories[index].name),
            onTap: () {
              setState(() {
                dire = directory.directories[index].name;
              });
              Navigator.pop(context);
            },
            trailing: IconButton(
              splashRadius: 20.0,
              onPressed: () async {
                if (directory.directories[index].name != '/') {
                  await database.transaction((txn) async {
                    await txn.rawDelete('DELETE FROM notes WHERE id = ?',
                        [directory.directories[index].id]);
                  });
                  return directory.removeDir(directory.directories[index]);
                }
              },
              icon: directory.directories[index].name != '/'
                  ? const Icon(Icons.delete, color: Colors.red)
                  : const Icon(null),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //TODO: change this in test
    double dynSize = size.height * 0.75;
    // Widget realNote() {
    //   var n = _noteBuilder(dire, imp, context);
    //   return n;
    // }

    _controller.addListener(() {
      setState(() {
        imp = _controller.text;
        //dynSize = size.height * 0.30;
      });
    });
    var note = context.watch<NoteModel>();
    var directory = context.watch<DirectoryModel>();
    return Scaffold(
      body: Column(children: [
        Container(
          height: size.height * 0.02,
          decoration: BoxDecoration(
              color: Colors.yellowAccent[700],
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        SizedBox(
          height: dynSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: size.height * 0.02,
                //   decoration: BoxDecoration(
                //       color: Colors.yellowAccent[700],
                //       borderRadius: const BorderRadius.only(
                //           bottomLeft: Radius.circular(20),
                //           bottomRight: Radius.circular(20))),
                // ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: note.items.length,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     return Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListTile(
                //       title: Text(note.items[index].title),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.0),
                //       ),
                //       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(note.items[index]))),
                //       trailing: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           IconButton(
                //             splashRadius: 20.0,
                //             onPressed: () => note.removeNote(note.items[index]),
                //             icon: const Icon(
                //               Icons.delete,
                //               color: Colors.red,
                //             ),
                //           ),
                //           IconButton(
                //             splashRadius: 20.0,
                //             onPressed: () {},
                //             icon: Icon(
                //               Icons.cloud,
                //               color: Colors.blue[700],
                //             )
                //           ),
                //         ],
                //       ),
                //       tileColor: Colors.amber,
                //     ),
                //   );
                //   }
                // ),
                Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 10.0, 10.0, 10.0),
                    child: Text(dire, style: const TextStyle(fontSize: 35.0))),
                FutureBuilder(
                    future: _noteBuilder(dire, imp, context),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        child = Container(child: snapshot.data);
                      } else if (snapshot.hasError) {
                        child = const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        );
                      } else {
                        child =
                            const Center(child: CircularProgressIndicator());
                      }
                      return child;
                    })
              ],
            ),
          ),
        )
      ]),

      drawer: Drawer(
        // child: ListView(
        //   padding: EdgeInsets.zero,
        //   children: [
        //     SizedBox(
        //       height: 115,
        //       child: DrawerHeader(
        //         margin: const EdgeInsets.only(bottom: 8.0),
        //         padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5.0),
        //         decoration: BoxDecoration(
        //           color: Colors.yellowAccent[700],
        //         ),
        //         child: const Text(
        //           'Directories',
        //           style: TextStyle(fontSize: 20),
        //         ),
        //       ),
        //     ),
        //     ListTile(
        //       leading: const Icon(Icons.folder),
        //       title: const Text('CSC 8000'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       leading: const Icon(Icons.folder),
        //       title: const Text('MTH 22000'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       leading: const Icon(Icons.folder),
        //       title: const Text('Lists'),
        //       onTap: () {},
        //     ),
        //     FloatingActionButton(
        //       onPressed: () {},
        //       child: const Icon(Icons.add)
        //     )
        //   ],
        // ),
        child: Column(children: [
          SizedBox(
            height: size.height * 0.16,
            width: size.width,
            child: DrawerHeader(
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.yellowAccent[700],
              ),
              child: const Text(
                'Directories',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          // ListView.builder(
          //   itemCount: directory.directories.length,
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) => Container(
          //     padding: const EdgeInsets.all(2),
          //     child: ListTile(
          //         //TODO add open and close feature
          //         leading: const Icon(Icons.folder),
          //         title: Text(directory.directories[index].name),
          //         onTap: () {
          //           setState(() {
          //             dire = directory.directories[index].name;
          //           });
          //           Navigator.pop(context);
          //         },
          //         trailing: IconButton(
          //           splashRadius: 20.0,
          //           onPressed: () {
          //             if (directory.directories[index].name != '/') {
          //               return directory
          //                   .removeDir(directory.directories[index]);
          //             }
          //           },
          //           icon: directory.directories[index].name != '/'
          //               ? const Icon(Icons.delete, color: Colors.red)
          //               : const Icon(null),
          //         )),
          //   ),
          // ),
          FutureBuilder(
              future: _directoryBuilder(directory),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  child = Container(child: snapshot.data);
                } else if (snapshot.hasError) {
                  child = const Center(
                      child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ));
                } else {
                  child = const Center(child: CircularProgressIndicator());
                }
                return child;
              }),
          FloatingActionButton(
              heroTag: "add_directory",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DirectoryWig(database2))),
              child: const Icon(Icons.add))
        ]),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellowAccent[700],
        elevation: 0,
        leading: Builder(
            builder: (_) => IconButton(
                  icon: SvgPicture.asset('assets/images/menu.svg'),
                  onPressed: () => Scaffold.of(_).openDrawer(),
                )),
        actions: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: AnimSearchBar(
                width: 300,
                textController: _controller,
                onSuffixTap: () {
                  setState(() {
                    _controller.clear();
                  });
                },
                closeSearchOnSuffixTap: true,
                suffixIcon: const Icon(Icons.cancel),
                prefixIcon: const Icon(Icons.search),
              ))
        ],
      ),

      // Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Note())
      floatingActionButton: GestureDetector(
        onLongPress: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => Note(database: database))),
        child: ExpandableFab(
          distance: 200.0,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.create),
            ),
            ActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Note(database: database))),
              icon: const Icon(Icons.note_add),
            ),
            ActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Note(database: database))),
              icon: const Icon(Icons.calculate),
            ),
          ],
        ),
      ),
    );
  }
}
