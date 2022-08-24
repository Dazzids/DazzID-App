import 'package:dazz/constants.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;
  ThemeData _currentTheme;

  ThemeChanger() {
    _currentTheme = _currentTheme == null ? dLightTheme : _currentTheme;
  }

  bool get lightTheme => !this._darkTheme;
  bool get darkTheme => this._darkTheme;
  ThemeData get currentTheme => this._currentTheme;

  set darkTheme(bool value) {
    this._darkTheme = value;

    if (value) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = dLightTheme;
    }

    notifyListeners();
  }
}
