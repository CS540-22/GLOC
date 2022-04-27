import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:gloc_ui/utilities/IconFunctions.dart';

class LanguageIcon {
  late String path;
  late ColorPalette colorPalette = ColorPalette.empty();
  bool recolorIcon = false;

  LanguageIcon(String languageName) {
    path = 'images/' + getLanguageImagePath(languageName);
    List<String> colorStrings = getLanguageImageColors(languageName);
    for (var i = 0; i < 3; i++) {
      if (i < colorStrings.length) {
        if (colorStrings[i] == '040404' && colorStrings.length == 1) {
          var color = HslColor(
              languageName.hashCode % 360,
              (languageName.hashCode % 10) + 70,
              (languageName.hashCode % 10) + 40);
          colorPalette.add(color);
          recolorIcon = true;
        } else {
          RgbColor color = RgbColor.fromHex(colorStrings[i]);
          colorPalette.add(color);
        }
      } else {
        var hslColor = HSLColor.fromColor(colorPalette[i - 1]);
        var newLightness = min(hslColor.lightness + .15, 1.0);
        colorPalette.add(hslColor.withLightness(newLightness).toColor());
      }
    }
    colorPalette.sortBy(ColorSortingProperty.darkest);
  }
}
