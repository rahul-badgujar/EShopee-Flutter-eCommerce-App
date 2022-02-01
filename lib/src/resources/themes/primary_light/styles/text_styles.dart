import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:flutter/material.dart';

class UiTextTheme {
  final TextTheme defaultTextTheme;

  UiTextTheme({required this.defaultTextTheme});

  TextStyle getHeaderTextStyle() {
    final existingStyle = defaultTextTheme.headline4 ?? const TextStyle();
    return existingStyle.copyWith(
      fontSize: 36,
      color: UiPalette.textDarkShade(4),
      fontWeight: FontWeight.bold,
    );
  }
}
