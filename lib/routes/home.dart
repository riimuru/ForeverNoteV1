import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/search_bar.dart';
import '../routes/sub/view_note.dart';

import 'sub/note.dart';
import 'sub/directory.dart';
import '../widgets/expandable_button.dart';
import '../../models/note.dart';
import '../../models/directory.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  String dire = '/';

  Widget _noteBuilder(String str, BuildContext context){
    var note = context.watch<NoteModel>();
    return ListView.builder(
                  shrinkWrap: true,
                  itemCount: note.items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) { 
                    if(str == '/'){
                    return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(note.items[index].title),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(note.items[index]))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            splashRadius: 20.0,
                            onPressed: () => note.removeNote(note.items[index]),
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
                            )
                          ),
                        ],
                      ),
                      tileColor: Colors.amber,
                    ),
                  );
                    }
                    else{
                      if(note.items[index].directory == dire){
                        return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(note.items[index].title),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(note.items[index]))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            splashRadius: 20.0,
                            onPressed: () => note.removeNote(note.items[index]),
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
                            )
                          ),
                        ],
                      ),
                      tileColor: Colors.amber,
                    ),
                  );
                  
                      }else{
                        return const SizedBox.shrink();
                      }
                    }
                  }
                );
  }

  @override
  Widget build(BuildContext context) {
    var note = context.watch<NoteModel>();
    var directory = context.watch<DirectoryModel>();
    Size size = MediaQuery.of(context).size;
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
          height: size.height * 0.75,
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
                  child: Text(dire, style: const TextStyle(fontSize: 35.0))
                ),
                _noteBuilder(dire, context)
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
        child: Column(
        children: [
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
          ListView.builder(
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
                onPressed: () { 
                  if(directory.directories[index].name != '/'){
                    return directory.removeDir(directory.directories[index]);
                  }
                },
                icon: directory.directories[index].name != '/' ? const Icon(Icons.delete, color: Colors.red) : const Icon(null),
              )
            ),
          ),
          ),
          FloatingActionButton(
              heroTag: "add_directory",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DirectoryWig())
              ),
              child: const Icon(Icons.add)
            )
        ]
        ),
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
        actions: const <Widget>[SearchBar()],
      ),

      // Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Note())
      floatingActionButton: GestureDetector(
        onLongPress: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Note())),
        child: ExpandableFab(
          distance: 200.0,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.create),
            ),
            ActionButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Note())),
              icon: const Icon(Icons.note_add),
            ),
            ActionButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Note())),
              icon: const Icon(Icons.calculate),
            ),
          ],
        ),
      ),
    );
  }
}
