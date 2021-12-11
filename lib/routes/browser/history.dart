import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history.dart';
import '../../utils/constants.dart';
import '../../services/database_helper.dart';
import '../search.dart';
import '../../widgets/warning_popup.dart';

class HistoryS extends StatefulWidget {
  const HistoryS({Key? key}) : super(key: key);

  @override
  _HistorySState createState() => _HistorySState();
}

class _HistorySState extends State<HistoryS> {
  Future<List<HistoryStructure>> _historyBuilder(BuildContext context) async {
    var res = await DatabaseHelper.db.getHistory();
    return res;
  }

  _navigateToBrowser(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(
          historyUrl: url,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var history = context.watch<HistoryModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: FutureBuilder(
          future: _historyBuilder(context),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.waiting:
                return Container();
              case ConnectionState.active:
                return Container();
              case ConnectionState.done:
                return (snapshot.data != null && snapshot.data.length > 0)
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          List<HistoryStructure> list =
                              List<HistoryStructure>.from(snapshot.data)
                                  .reversed
                                  .toList();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(list[index].host),
                              subtitle: RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: list[index].url,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network(
                                    (list[index].favicon != null)
                                        ? list[index].favicon.toString()
                                        : Constant.DEFAULT_FAVICON,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onTap: () => _navigateToBrowser(
                                context,
                                list[index].url,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    splashRadius: 20.0,
                                    onPressed: () =>
                                        history.removeHistory(list[index]),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 20.0,
                                    onPressed: () => print("TODO"),
                                    icon: const Icon(
                                      Icons.cloud,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Search history appear here.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.clear_all,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => WarningPopUp(
            "Delete all searched history? ",
            context,
            history,
          ),
        ),
      ),
    );
  }
}
