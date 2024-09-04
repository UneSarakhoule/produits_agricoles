import 'package:flutter/material.dart';
import '../../models/constants.dart';

class Styles{
  static ThemeData themeData({required bool isDarkTheme, required BuildContext context}){
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? Constants().blackColor
          : Constants().thirtyColor,
      cardColor: isDarkTheme
          ?const Color.fromARGB(255, 13, 6, 37)
          : Constants().white2Color,
      brightness: isDarkTheme
          ? Brightness.dark
          : Brightness.light
    );
  }

}
