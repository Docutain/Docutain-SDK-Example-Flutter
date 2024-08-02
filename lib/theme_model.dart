import 'package:docutain_sdk_example_flutter/settings/utils.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  Color primaryColor;
  Color secondaryColor;

  AppThemeData({
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class AppColorsLight {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryVariant = Color(0xFF388E3C);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryVariant = Color(0xFF388E3C);
  static const Color onSecondary = Colors.white;
  static const Color topBarsBackground = Color(0xFF4CAF50);
  static const Color topBarsForeground = Colors.white;
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  static const Color docutainColorPrimary = Color(0xFF4CAF50);
  static const Color docutainColorSecondary = Color(0xFF4CAF50);
  static const Color docutainColorOnSecondary = Colors.white;

  static const Color docutainColorScanButtonsLayoutBackground = Color(0xFF121212);
  static const Color docutainColorScanButtonsForeground = Colors.white;
  static const Color docutainColorSurfaceBelowImage = Color(0xFFE9E9E9);
  static const Color docutainColorScanPolygon = Color(0xFF4CAF50);
  static const Color docutainColorBottomBarBackground = Colors.white;
  static const Color docutainColorBottomBarForeground = Color(0xFF323232);
  static const Color docutainColorTopBarBackground = Color(0xFF4CAF50);
  static const Color docutainColorTopBarForeground = Colors.white;
  static const Color docutainColorRipple = Color(0xFF33969696);
  static const Color docutainColorStatusBar = Color(0xFF4CAF50);
  static const Color docutainColorError = Color(0xFFB00020);
  static const Color lineColor = Color(0xffdb999999);
}


class AppColorsDark {
  static const Color primary = Color(0xFF58AC5B);
  static const Color primaryVariant = Color(0xFF388E3C);
  static const Color onPrimary = Color(0xFF000000);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryVariant = Color(0xFF388E3C);
  static const Color onSecondary = Colors.white;
  static const Color topBarsBackground = Color(0xFF2A2A2A);
  static const Color topBarsForeground = Color(0xFFDEffffff);

  static const Color docutainColorSecondary = Color(0xFF4CAF50);
  static const Color docutainColorOnSecondary = Color(0xFF000000);
  static const Color docutainColorPrimary = Color(0xFF4CAF50);
  static const Color docutainColorScanButtonsLayoutBackground = Color(0xFF121212);
  static const Color docutainColorScanButtonsForeground = Color(0xFFFFFFFF);
  static const Color docutainColorSurfaceBelowImage = Color(0xFF090909);
  static const Color docutainColorScanPolygon = Color(0xFF4CAF50);
  static const Color docutainColorBottomBarBackground = Color(0xFF212121);
  static const Color docutainColorBottomBarForeground = Color(0xFFBEBEBE);
  static const Color docutainColorTopBarBackground = Color(0xFF2A2A2A);
  static const Color docutainColorTopBarForeground = Color(0xDEffffff);
  static const Color docutainColorRipple = Color(0xFF33969696);
  static const Color docutainColorError = Color(0xFFB00020);
}

class ThemeModel with ChangeNotifier {
  ThemeData darkModeTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      background: AppColorsDark.onPrimary,
      brightness: Brightness.dark,
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      error: AppColorsDark.docutainColorError,
      onError: AppColorsDark.docutainColorError,
      onBackground: AppColorsDark.onPrimary,
      surface:  AppColorsDark.onSecondary,
      onSurface: AppColorsDark.onSecondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.topBarsBackground,
      foregroundColor: AppColorsDark.topBarsForeground,
    ),
  );

  ThemeData lightModeTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      background:AppColorsLight.onPrimary,
      brightness: Brightness.light,
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.onPrimary,
      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.onSecondary,
      error: AppColorsLight.docutainColorError,
      onError: AppColorsLight.docutainColorError,
      onBackground: Colors.black,
      surface: AppColorsLight.onPrimary,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.topBarsBackground,
      foregroundColor: AppColorsLight.topBarsForeground,
    ),
  );

  ThemeMode _currentThemeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void setThemeMode(bool darkmode) {
    _currentThemeMode = darkmode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  String getIconName() {
    return _currentThemeMode == ThemeMode.light ? '_black.png' : '_white.png';
  }

  String getModeColor(BuildContext context, Color light, Color night) {
    return colorToHexString(
        Theme.of(context).brightness == Brightness.light ? light : night);
  }
}