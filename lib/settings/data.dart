import 'package:docutain_sdk/docutain_sdk_ui.dart';
import 'package:flutter/material.dart';

abstract class SettingsMultiItems {}

class TitleItem extends SettingsMultiItems {
  final String title;

  TitleItem({required this.title});
}

class ColorItem extends SettingsMultiItems {
  final String title;
  final String subtitle;
  final String lightCircle;
  final String darkCircle;
  final ColorSetting colorKey;

  ColorItem({
    required this.title,
    required this.subtitle,
    required this.lightCircle,
    required this.darkCircle,
    required this.colorKey,
  });
}

class ScanSettingsItem extends SettingsMultiItems {
  final String title;
  final String subtitle;
  final bool checkValue;
  final ScanSetting scanKey;

  ScanSettingsItem({
    required this.title,
    required this.subtitle,
    required this.checkValue,
    required this.scanKey,
  });
}

class ScanFilterItem extends SettingsMultiItems {
  final String title;
  final String subtitle;
  final ScanFilter scanValue;
  final ScanSetting filterKey;

  ScanFilterItem({
    required this.title,
    required this.subtitle,
    required this.scanValue,
    required this.filterKey,
  });
}

class EditItem extends SettingsMultiItems {
  final String title;
  final String subtitle;
  final bool editValue;
  final EditSetting editKey;

  EditItem({
    required this.title,
    required this.subtitle,
    required this.editValue,
    required this.editKey,
  });
}

enum ColorSetting {
  ColorPrimary,
  ColorSecondary,
  ColorOnSecondary,
  ColorScanButtonsLayoutBackground,
  ColorScanButtonsForeground,
  ColorScanPolygon,
  ColorBottomBarBackground,
  ColorBottomBarForeground,
  ColorTopBarBackground,
  ColorTopBarForeground,
}

enum ColorType {
  Light,
  Dark,
}

enum ScanSetting {
  AllowCaptureModeSetting,
  AutoCapture,
  AutoCrop,
  MultiPage,
  PreCaptureFocus,
  DefaultScanFilter,
}

enum EditSetting {
  AllowPageFilter,
  AllowPageRotation,
  AllowPageArrangement,
  AllowPageCropping,
  PageArrangementShowDeleteButton,
  PageArrangementShowPageNumber,
}
