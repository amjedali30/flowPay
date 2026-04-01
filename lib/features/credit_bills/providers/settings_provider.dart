import 'package:flutter/material.dart';

enum UpiEntryMode { single, multiple }

class SettingsProvider with ChangeNotifier {
  UpiEntryMode _upiEntryMode = UpiEntryMode.multiple;

  UpiEntryMode get upiEntryMode => _upiEntryMode;

  Future<void> init() async {
    // In a real app, load from SharedPreferences
    notifyListeners();
  }

  void setUpiEntryMode(UpiEntryMode mode) {
    _upiEntryMode = mode;
    notifyListeners();
  }
}
