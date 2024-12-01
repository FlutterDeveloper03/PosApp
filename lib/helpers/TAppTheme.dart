// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/StorageManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff003A3E),
    primaryColor: const Color(0xFF00565B),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      shadow: Colors.transparent,
      secondaryContainer: Color(0xff444444),
      secondary: Colors.cyanAccent,
      onSecondary: Color(0xFF1DA2A9),
      onSecondaryContainer: Color(0xFF00565B),
    ),
      textTheme:const TextTheme(
        labelMedium:TextStyle(color:Colors.white),
        labelSmall:TextStyle(color:Colors.white),
      ),
    indicatorColor: const Color(0xffFED931),
    dividerColor: Colors.white,
    shadowColor: Colors.transparent,
    cardColor: Colors.white,
    canvasColor: Colors.black,
    secondaryHeaderColor: Colors.white
  );

  final lightTheme = ThemeData(
    applyElevationOverlayColor: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffF6F6F6),
    primaryColor: const Color(0xff01A9B4),
    indicatorColor: const Color(0xffFED931),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      shadow: Colors.transparent,
      secondary: Colors.cyanAccent,
      onSecondary: Color(0xff29c3ce),
      onSecondaryContainer: Colors.white,
      secondaryContainer: Color(0xff444444),
    ),

      textTheme:const TextTheme(
        labelMedium:TextStyle(color:Colors.white),
        labelSmall:TextStyle(color:Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white
      ),
    dividerColor: Colors.white,
    cardColor: Colors.white,
    canvasColor: Colors.black,
    shadowColor: Colors.transparent,
    secondaryHeaderColor: Colors.black
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData(SharedPrefKeys.theme).then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData(SharedPrefKeys.theme, 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData(SharedPrefKeys.theme, 'light');
    notifyListeners();
  }
}