import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/downloads.dart';
import '../search.dart';
import '../../services/database_helper.dart';
import '../../utils/constants.dart';
import '../../widgets/warning_popup1.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  Future<List<DownloadStructure>> _downloadBuilder(BuildContext context) async {
    var res = await DatabaseHelper.db.getDownloads();
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
    var download = context.watch<DownloadModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Downloads",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: FutureBuilder(
          future: _downloadBuilder(context),
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
                          List<DownloadStructure> list =
                              List<DownloadStructure>.from(snapshot.data)
                                  .reversed
                                  .toList();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                list[index].host,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              subtitle: RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: list[index].url,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
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
                                        download.removeDownload(list[index]),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 20.0,
                                    onPressed: () {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: Text(
                                            "Added to loud storage.",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                          "Downloads appear here.",
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
          builder: (context) => WarningPopUp1(
            "Delete all downloads? ",
            context,
            download,
          ),
        ),
      ),
    );
  }
}
