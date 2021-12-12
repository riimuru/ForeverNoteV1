import 'package:flutter/material.dart';

class LightDark extends ChangeNotifier{
  bool _option = true;

  void toggle() {
    _option = !_option;
    notifyListeners();
  }

  bool get opiton => _option;
}