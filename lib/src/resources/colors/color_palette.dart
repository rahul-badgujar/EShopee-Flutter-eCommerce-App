import 'dart:math';
import '../values/dimens.dart';
import 'package:flutter/material.dart';

class UiPalette {
  static Color primaryColor = const Color(0xFFFF7643);
  static MaterialColor primarySwatch = generateMaterialColor(primaryColor);

  static const Color scaffoldBgColor = Color.fromARGB(255, 252, 252, 252);

  static Color textDarkShade(int shade) {
    int value = (shade * 16 - 1) % 256;
    if (value < 0) value = 0;
    return Color.fromARGB(255, value, value, value);
  }

  static Color textLightShade(int shade) {
    shade = 16 - shade;
    int value = (shade * 16 - 1) % 256;
    if (value < 0) value = 0;
    return Color.fromARGB(255, value, value, value);
  }

  static Color freeEventRegistrationButtonColor = Colors.greenAccent.shade700;
  static Color paidEventRegistrationButtonColor = Colors.amber.shade600;

  static Color primaryColorShadow =
      UiPalette.primaryColor.withOpacity(Dimens.defaultShadowColorOpacity);

  static Color newItemBubbleColor = UiPalette.textLightShade(0);

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) {
    return max(0, min((value + ((255 - value) * factor)).round(), 255));
  }

  static Color tintColor(Color color, double factor) {
    return Color.fromRGBO(tintValue(color.red, factor),
        tintValue(color.green, factor), tintValue(color.blue, factor), 1);
  }

  static int shadeValue(int value, double factor) {
    return max(0, min(value - (value * factor).round(), 255));
  }

  static Color shadeColor(Color color, double factor) {
    return Color.fromRGBO(shadeValue(color.red, factor),
        shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);
  }
}
