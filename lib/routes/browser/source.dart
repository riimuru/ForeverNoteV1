import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Source extends StatefulWidget {
  InAppWebViewController? _controller;
  Uri url;
  Source(this._controller, this.url);

  @override
  State<Source> createState() => _SourceState(this._controller, this.url);
}

class _SourceState extends State<Source> {
  InAppWebViewController? _controller;
  Uri url;
  String? source;
  _SourceState(this._controller, this.url);

  @override
  void initState() {
    super.initState();
  }

  Future getSource() async {
    if (_controller != null) {
      source = await _controller?.getHtml();
      return source;
    }
  }

  @override
  Widget build(BuildContext context) {
    getSource();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Source - ${widget.url.host}",
          style: const TextStyle(color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.yellowAccent[700],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: FutureBuilder(
        future: getSource(),
        builder: (context, AsyncSnapshot snapshot) {
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
              if (snapshot.hasData) source = snapshot.data;

              return (source == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (snapshot.hasData)
                      ? SingleChildScrollView(child: Text(snapshot.data))
                      : const Center(
                          child: Text("Unable to get source code."),
                        );
          }
        },
      ),
    );
  }
}
