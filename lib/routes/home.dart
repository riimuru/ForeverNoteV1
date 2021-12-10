import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/search_bar.dart';

import '../../routes/note.dart';
import '../widgets/expandable_button.dart';
import '../../models/note.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var note = context.watch<NoteModel>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.02,
              decoration: BoxDecoration(
                  color: Colors.yellowAccent[700],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: note.itemsCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(note.items[index].title),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () => note.removeNote(note.items[index]),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  tileColor: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 115,
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
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('CSC 8000'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('MTH 22000'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Lists'),
                  onTap: () {},
                ),
              ],
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
              )
            ),
            actions: const <Widget>[SearchBar()],
          ),

      // Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Note())
      floatingActionButton: GestureDetector(
        onLongPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Note())),
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