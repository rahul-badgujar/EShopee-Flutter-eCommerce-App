import 'package:eshopee/src/resources/themes/primary_light/styles/text_styles.dart';

import '../../colors/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryLightTheme {
  bool _isInitialized = false;

  late final ThemeData theme;
  late final UiTextTheme textTheme;

  PrimaryLightTheme._();
  static final instance = PrimaryLightTheme._();

  void init(BuildContext context) {
    // avoid reinit if already initialized
    if (!_isInitialized) {
      final defaultTheme = Theme.of(context);

      theme = ThemeData(
        brightness: Brightness.light,
        primarySwatch: UiPalette.primarySwatch,
        primaryColor: UiPalette.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: UiPalette.scaffoldBgColor,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: defaultTheme.appBarTheme.copyWith(),
      );

      textTheme = UiTextTheme(defaultTextTheme: theme.textTheme);

      // set initialized
      _isInitialized = true;
    }
  }

  AppBarTheme get appBarTheme {
    return theme.appBarTheme;
  }

  AppBarTheme get appBarNoElevationTheme {
    return appBarTheme.copyWith(
      elevation: 0,
    );
  }

  AppBarTheme get lightAppBarNoElevationTheme {
    return appBarNoElevationTheme.copyWith(
      backgroundColor: UiPalette.scaffoldBgColor,
      foregroundColor: UiPalette.textDarkShade(3),
    );
  }
}
