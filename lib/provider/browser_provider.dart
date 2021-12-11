import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowserProvider extends ChangeNotifier {
  bool desktopMode;

  BrowserProvider(this.desktopMode);

  bool get isDesktopMode => desktopMode;

  bool toggleMode(bool isDesktopMode) {
    desktopMode = !isDesktopMode;
    notifyListeners();
    return isDesktopMode;
  }
}
