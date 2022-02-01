import 'package:eshopee/src/resources/themes/primary_light/styles/text_styles.dart';
import 'package:eshopee/src/resources/values/dimens.dart';

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
        inputDecorationTheme:
            _generateInputDecorationTheme(defaultTheme.inputDecorationTheme),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black,
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      );

      textTheme = UiTextTheme(defaultTextTheme: theme.textTheme);

      // set initialized
      _isInitialized = true;
    }
  }

  InputDecorationTheme get inputDecorationTheme {
    return theme.inputDecorationTheme;
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

  InputDecorationTheme _generateInputDecorationTheme(
      InputDecorationTheme referenceInputDecorationTheme) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.inputFieldCornerRadius),
      borderSide: BorderSide(color: UiPalette.textDarkShade(5)),
      gapPadding: 10,
    );
    return referenceInputDecorationTheme.copyWith(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: Dimens.inputFieldContentPadding,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder.copyWith(
        borderSide: BorderSide(color: UiPalette.primaryColor),
      ),
      border: outlineInputBorder,
    );
  }
}
