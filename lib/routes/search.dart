import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../routes/downloads.dart';
import '../routes/history.dart';
import '../utils/constants.dart';
import '../widgets/certificate_popup.dart';
import '../models/history.dart';
import '../provider/browser_provider.dart';
import '../widgets/download.popup.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  InAppWebViewController? _webViewController;
  final TextEditingController _controller = TextEditingController();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      useOnDownloadStart: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  String url = Constant.DEFAULT_URL;
  String? favicon;
  double progress = 0;
  SslCertificate? certificate;
  X509Certificate? x509certificate;
  bool? canGoBack = false;
  bool? canGoForward = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavicon() async {
    if (_webViewController != null) {
      var favicons = await _webViewController?.getFavicons();
      if (favicons!.isNotEmpty) {
        favicon = favicons[0].url.toString();
      }
    }
  }

  getWebSiteCertificates(BuildContext context) async {
    var ssl = await _webViewController?.getCertificate();
    certificate = ssl;
    showDialog(
        context: context,
        builder: (context) => CertificatePopUp(ssl, Uri.parse(url)));
  }

  selectedItem(context, item) {
    switch (item) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Downloads()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HistoryS()));
        break;
    }
  }

  initArrows() async {
    if (_webViewController != null) {
      canGoBack = await _webViewController?.canGoBack();
      canGoForward = await _webViewController?.canGoForward();
    }
  }

  @override
  Widget build(BuildContext context) {
    BrowserProvider browserProvider = Provider.of<BrowserProvider>(context);

    getFavicon();
    var history = context.watch<HistoryModel>();
    if (_webViewController != null && browserProvider.isDesktopMode) {
      _webViewController?.evaluateJavascript(
        source: Constant.enableDesktopModeJs,
      );
    } else if (_webViewController != null) {
      _webViewController?.evaluateJavascript(
        source: Constant.desableDesktopModeJs,
      );
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellowAccent[700],
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: GestureDetector(
                onTap: () => getWebSiteCertificates(context),
                child: Image.network(
                  (favicon != null)
                      ? favicon.toString()
                      : Constant.DEFAULT_FAVICON,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
              child: TextField(
                keyboardType: TextInputType.url,
                autofocus: false,
                controller: _controller,
                cursorColor: Colors.black,
                cursorWidth: 1,
                textInputAction: TextInputAction.go,
                onSubmitted: (val) {
                  var url = Uri.parse(val);
                  if (url.scheme.isEmpty) {
                    this.url = Constant.DEFAULT_URL + val;
                  }
                  _webViewController?.loadUrl(
                      urlRequest: URLRequest(url: Uri.parse(this.url)));
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  prefixIcon: (Uri.parse(url).isScheme("HTTPS"))
                      ? GestureDetector(
                          onTap: () => getWebSiteCertificates(context),
                          child: const Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => getWebSiteCertificates(context),
                          child: const Icon(
                            Icons.lock_open,
                            color: Colors.red,
                          ),
                        ),
                  contentPadding: const EdgeInsets.only(
                      left: 8.0, bottom: 8.0, top: 8.0, right: 8.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  hintText: "Enter Url",
                  hintStyle: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          PopupMenuButton<int>(
            padding: const EdgeInsets.all(8.0),
            icon: const Icon(
              Icons.more_vert_outlined,
            ), //don't specify icon if you want 3 dot menu
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) => Row(
                    children: [
                      IconButton(
                        icon: (canGoBack != null && canGoBack!)
                            ? const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black38,
                              ),
                        onPressed: () {
                          if (_webViewController != null) {
                            _webViewController?.goBack() ?? "";
                            setState(() {
                              initArrows();
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: (canGoForward != null && canGoForward!)
                            ? const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black38,
                              ),
                        onPressed: () {
                          if (_webViewController != null) {
                            _webViewController?.goForward() ?? "";
                            setState(() {
                              initArrows();
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          if (_webViewController != null) {
                            _webViewController?.reload() ?? "";
                          }
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text(
                  "Downloads",
                  style: TextStyle(
                    fontSize: 16.5,
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text(
                  "History",
                  style: TextStyle(
                    fontSize: 16.5,
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) =>
                      CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 0.0,
                    ),
                    title: const Text(
                      "Desktop site",
                      style: TextStyle(
                        fontSize: 16.5,
                      ),
                    ),
                    value: browserProvider.isDesktopMode,
                    onChanged: (newVal) {
                      Provider.of<BrowserProvider>(context, listen: false)
                          .toggleMode(browserProvider.isDesktopMode);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
            onSelected: (item) => selectedItem(context, item),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              initialOptions: options,
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) async {
                setState(() {
                  this.url = url.toString();
                  _controller.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                setState(() {
                  this.url = url.toString();
                  _controller.text = this.url;
                  initArrows();
                });
                var histories = context.read<HistoryModel>();
                histories.add(
                  HistoryStructure(
                    id: history.items.length,
                    favicon: favicon!,
                    host: Uri.parse(this.url).host,
                    url: this.url,
                  ),
                );
              },
              onProgressChanged: (controller, progress) async {
                setState(() {
                  this.progress = progress / 100;
                  _controller.text = url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) async {
                setState(() {
                  this.url = url.toString();
                  _controller.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              onDownloadStart: (controller, url) async {
                //TODO: download using webview
                print(url.data?.parameters.toString());
                // FlutterDownloader.registerCallback(TestClass.callback);
                // var directory = await getExternalStorageDirectory();

                showDialog(
                    context: context,
                    builder: (context) => const DownloadPopUp());
                // final taskId = await FlutterDownloader.enqueue(
                //   url: url.toString(),
                //   savedDir: directory!.path,
                //   showNotification:
                //       true, // show download progress in status bar (for Android)
                //   openFileFromNotification:
                //       true, // click on notification to open downloaded file (for Android)
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}
