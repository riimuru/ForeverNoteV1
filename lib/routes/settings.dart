import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:forever_note/services/database_helper.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/downloads.dart';
import '../models/history.dart';
import '../models/note.dart';
import '../models/directory.dart';
import '../widgets/warning_popup2.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  var testtog = false;

  _deleteEverything(context) {}

  @override
  Widget build(BuildContext context) {
    var isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var history = context.watch<HistoryModel>();
    var download = context.watch<DownloadModel>();
    var directory = context.watch<DirectoryModel>();
    var note = context.watch<NoteModel>();

    return Scaffold(
      //backgroundColor: context.watch<ThemeProvider>().opiton ? const Color.fromRGBO(255, 253, 237, 1.0) : const Color.fromRGBO(41, 39, 33, 1.0),
      body: SafeArea(
        child: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "Appearance",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: FlutterSwitch(
                        value: themeProvider.isDarkMode,
                        onToggle: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          prefs.setString(
                              Constant.APP_THEME, value ? "Dark" : "Light");

                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(value);
                        },
                        activeIcon: const Icon(Icons.wb_sunny,
                            color: Colors.yellow, size: 60.0),
                        activeToggleColor: Colors.blue[900],
                        inactiveIcon: const Icon(Icons.nightlight,
                            color: Colors.amber, size: 60.0),
                        inactiveToggleColor: Colors.purple[900],
                        activeSwitchBorder:
                            Border.all(width: 2.5, color: Colors.black),
                        inactiveSwitchBorder:
                            Border.all(width: 2.5, color: Colors.grey),
                        inactiveColor: Colors.white,
                        inactiveToggleBorder:
                            Border.all(width: 2.0, color: Colors.blue),
                        activeToggleBorder:
                            Border.all(width: 2.0, color: Colors.white),
                        height: 40.0,
                        width: 90.0,
                        toggleSize: 30.0,
                      ))
                ],
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Divider(
                      thickness: 2.0,
                      indent: 10.0,
                      endIndent: 10.0,
                      color: Theme.of(context).primaryColor)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text("Delete Everything",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: OutlinedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => WarningPopUp2(
                            context,
                            download,
                            note,
                            history,
                            DatabaseHelper.db,
                            "Are you sure you want to delete everything?"),
                      ),
                      child: const Icon(Icons.delete, color: Colors.black),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
