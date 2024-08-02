import 'package:docutain_sdk/docutain_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme_model.dart';
import 'data.dart';

class SettingsSharedPreferences {
  final SharedPreferences _prefs;

  SettingsSharedPreferences(this._prefs);

  void saveColorItem(ColorSetting key, String lightColor, String darkColor) {
    _prefs.setString('${key.toString().toLowerCase()}_light_color', lightColor);
    _prefs.setString('${key.toString().toLowerCase()}_dark_color', darkColor);
  }

  void saveColorItemLight(String key, String color) {
    _prefs.setString('${key.toLowerCase()}_light_color', color);
  }

  void saveColorItemDark(String key, String color) {
    _prefs.setString('${key.toLowerCase()}_dark_color', color);
  }

  void saveEditItem(EditSetting key, bool value) {
    _prefs.setBool('${key.toString().toLowerCase()}_edit_value', value);
  }

  void saveScanItem(ScanSetting key, bool value) {
    _prefs.setBool('${key.toString().toLowerCase()}_scan_value', value);
  }

  void saveScanFilterItem(ScanSetting key, int value) {
    _prefs.setInt('${key.toString().toLowerCase()}_filter_value', value);
  }

  ColorItem getColorItem(ColorSetting key) {
    final color1 =
        _prefs.getString('${key.toString().toLowerCase()}_light_color') ?? '';
    final color2 =
        _prefs.getString('${key.toString().toLowerCase()}_dark_color') ?? '';
    return ColorItem(
      title: "",
      subtitle: "",
      lightCircle: color1,
      darkCircle: color2,
      colorKey: key,
    );
  }

  EditItem getEditItem(EditSetting key) {
    final checkValue =
        _prefs.getBool('${key.toString().toLowerCase()}_edit_value') ?? false;
    return EditItem(
      title: "",
      subtitle: "",
      editValue: checkValue,
      editKey: key,
    );
  }

  ScanSettingsItem getScanItem(ScanSetting key) {
    final scanValue =
        _prefs.getBool('${key.toString().toLowerCase()}_scan_value') ?? false;
    return ScanSettingsItem(
      title: "",
      subtitle: "",
      checkValue: scanValue,
      scanKey: key,
    );
  }

  ScanFilterItem getScanFilterItem(ScanSetting key) {
    final scanValue =
        _prefs.getInt('${key.toString().toLowerCase()}_filter_value') ??
            ScanFilter.illustration.index;
    return ScanFilterItem(
      title: "",
      subtitle: "",
      scanValue: ScanFilter.values[scanValue],
      filterKey: key,
    );
  }

  bool isEmpty() {
    return _prefs.getKeys().isEmpty;
  }

  void defaultColorPrimary() {
    String lightColor = colorToHex(AppColorsLight.docutainColorPrimary);
    String darkColor = colorToHex(AppColorsDark.docutainColorPrimary);
    saveColorItem(ColorSetting.ColorPrimary, lightColor, darkColor);
  }

  void defaultColorSecondary() {
    saveColorItem(
      ColorSetting.ColorSecondary,
      colorToHex(AppColorsLight.docutainColorSecondary),
      colorToHex(AppColorsDark.docutainColorSecondary),
    );
  }

  void defaultColorOnSecondary() {
    String lightColor = colorToHex(AppColorsLight.docutainColorOnSecondary);
    String darkColor = colorToHex(AppColorsDark.docutainColorOnSecondary);
    saveColorItem(ColorSetting.ColorOnSecondary, lightColor, darkColor);
  }

  void defaultColorScanButtonsLayoutBackground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorScanButtonsLayoutBackground);
    String darkColor =
        colorToHex(AppColorsDark.docutainColorScanButtonsLayoutBackground);
    saveColorItem(
        ColorSetting.ColorScanButtonsLayoutBackground, lightColor, darkColor);
  }

  void defaultColorScanButtonsForeground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorScanButtonsForeground);
    String darkColor =
        colorToHex(AppColorsDark.docutainColorScanButtonsForeground);
    saveColorItem(
        ColorSetting.ColorScanButtonsForeground, lightColor, darkColor);
  }

  void defaultColorScanPolygon() {
    String lightColor = colorToHex(AppColorsLight.docutainColorScanPolygon);
    String darkColor = colorToHex(AppColorsDark.docutainColorScanPolygon);
    saveColorItem(ColorSetting.ColorScanPolygon, lightColor, darkColor);
  }

  void defaultColorBottomBarBackground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorBottomBarBackground);
    String darkColor =
        colorToHex(AppColorsDark.docutainColorBottomBarBackground);
    saveColorItem(ColorSetting.ColorBottomBarBackground, lightColor, darkColor);
  }

  void defaultColorBottomBarForeground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorBottomBarForeground);
    String darkColor =
        colorToHex(AppColorsDark.docutainColorBottomBarForeground);
    saveColorItem(ColorSetting.ColorBottomBarForeground, lightColor, darkColor);
  }

  void defaultColorTopBarBackground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorTopBarBackground);
    String darkColor = colorToHex(AppColorsDark.docutainColorTopBarBackground);
    saveColorItem(ColorSetting.ColorTopBarBackground, lightColor, darkColor);
  }

  void defaultColorTopBarForeground() {
    String lightColor =
        colorToHex(AppColorsLight.docutainColorTopBarForeground);
    String darkColor = colorToHex(AppColorsDark.docutainColorTopBarForeground);
    saveColorItem(ColorSetting.ColorTopBarForeground, lightColor, darkColor);
  }

  Future<void> defaultSettings() async {
    defaultColorPrimary();
    defaultColorOnSecondary();
    defaultColorSecondary();
    defaultColorScanButtonsLayoutBackground();
    defaultColorScanButtonsForeground();
    defaultColorScanPolygon();
    defaultColorBottomBarForeground();
    defaultColorTopBarBackground();
    defaultColorTopBarForeground();
    defaultColorBottomBarBackground();

    saveScanItem(ScanSetting.AllowCaptureModeSetting, false);
    saveScanItem(ScanSetting.AutoCapture, true);
    saveScanItem(ScanSetting.AutoCrop, true);
    saveScanItem(ScanSetting.MultiPage, true);
    saveScanItem(ScanSetting.PreCaptureFocus, true);
    saveScanFilterItem(
        ScanSetting.DefaultScanFilter, ScanFilter.illustration.index);

    saveEditItem(EditSetting.AllowPageFilter, true);
    saveEditItem(EditSetting.AllowPageRotation, true);
    saveEditItem(EditSetting.AllowPageArrangement, true);
    saveEditItem(EditSetting.AllowPageCropping, true);
    saveEditItem(EditSetting.PageArrangementShowDeleteButton, false);
    saveEditItem(EditSetting.PageArrangementShowPageNumber, true);
  }
}
