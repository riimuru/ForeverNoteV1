import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history.dart';
import '../utils/constants.dart';

class HistoryS extends StatefulWidget {
  const HistoryS({Key? key}) : super(key: key);

  @override
  _HistorySState createState() => _HistorySState();
}

class _HistorySState extends State<HistoryS> {
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
      body: history.items.length - 1 > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: history.itemsCount,
              itemBuilder: (context, index) {
                var list = history.items.reversed.toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(list[index].host),
                    subtitle: Text(
                      list[index].url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    onTap: () {}, // TODO: take user to browser with clicked url
                  ),
                );
              })
          : const Center(
              child: Text(
                "History appears here.",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.clear_all,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        //TODO: clear search history
        onPressed: () {},
      ),
    );
  }
}
