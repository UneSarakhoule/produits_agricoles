import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  static const themeStatus = "THEME_STATUS";
  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;

  ThemeProvider(){
    getTheme(themevalue: true);
  }

  Future<void> setDarkTheme({required bool themevalue}) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(themeStatus, themevalue);

    _darkTheme = themevalue;
    notifyListeners();
  }

  Future<bool> getTheme({required bool themevalue}) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    _darkTheme = preferences.getBool(themeStatus) ?? false;
    notifyListeners();
    return _darkTheme;

  }

}