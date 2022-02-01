import '../colors/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData primaryThemeLight(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: UiPalette.primarySwatch,
      primaryColor: UiPalette.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: UiPalette.scaffoldBgColor,
      textTheme: textTheme(context),
      appBarTheme: defaultAppBarTheme,
    );
  }

  static ThemeData primaryThemeDark(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: UiPalette.primarySwatch,
      primaryColor: UiPalette.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme(context),
    );
  }

  static TextTheme textTheme(BuildContext context) {
    final currentTextTheme = GoogleFonts.latoTextTheme();
    return currentTextTheme.copyWith(
      headline3: currentTextTheme.headline1?.copyWith(color: Colors.black),
    );
  }

  static AppBarTheme get defaultAppBarTheme {
    return const AppBarTheme(
      elevation: 0,
    );
  }

  static AppBarTheme get lightAppBarTheme {
    return defaultAppBarTheme.copyWith(
      backgroundColor: UiPalette.scaffoldBgColor,
      foregroundColor: UiPalette.textDarkShade(3),
    );
  }
}
