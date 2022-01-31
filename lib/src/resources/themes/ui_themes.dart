import '../colors/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData get primaryThemeLight {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: UiPalette.primarySwatch,
      primaryColor: UiPalette.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: UiPalette.scaffoldBgColor,
      textTheme: GoogleFonts.latoTextTheme().copyWith(),
      appBarTheme: defaultAppBarTheme,
    );
  }

  static ThemeData get primaryThemeDark {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: UiPalette.primarySwatch,
      primaryColor: UiPalette.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.latoTextTheme().copyWith(),
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
