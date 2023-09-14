import 'package:flutter/material.dart';

class AppThemeData {
  Color primaryColor;
  Color secondaryColor;
  AppThemeData({
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class ThemeModel with ChangeNotifier {
  ThemeData darkModeTheme = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        background: Color(0xff0d0d0d),
        brightness: Brightness.dark,
        primary: Colors.green,
        onPrimary: Colors.black,
        secondary: Colors.greenAccent,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff2a2a2a),
          foregroundColor: Colors.white //here you can give the text color
          ));
  ThemeData lightModeTheme = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        background: Color.fromRGBO(239, 246, 249, 1),
        brightness: Brightness.light,
        primary: Colors.green,
        onPrimary: Colors.black,
        secondary: Colors.greenAccent,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff4caf50),
          foregroundColor: Colors.white //here you can give the text color
          ));

  ThemeMode _currentThemeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void setThemeMode(bool darkmode) {
    _currentThemeMode = darkmode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  String getIconName() {
    return _currentThemeMode == ThemeMode.light ? '_black.png' : '_white.png';
  }
}
