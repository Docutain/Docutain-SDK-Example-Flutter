
import 'package:flutter/material.dart';

String colorToHexString(Color color) {
  // Include alpha value
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

Color hexStringToColor(String hexColor) {
  String colorStr = hexColor.toUpperCase().replaceAll("#", "");
  if (colorStr.length == 6) {
    colorStr = 'FF$colorStr';
  }
  return Color(int.parse(colorStr, radix: 16));
}

String getModeColor(BuildContext context, Color light, Color night) {
  return colorToHexString(
      Theme.of(context).brightness == Brightness.light ? light : night);
}