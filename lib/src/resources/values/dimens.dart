import 'package:flutter/cupertino.dart';

class Dimens {
  bool _isInitialized = false;

  Dimens._();
  static final Dimens instance = Dimens._();

  static const double boxCornerRadius = 28;
  static const double buttonCornerRadius = 16;
  static const double inputFieldCornerRadius = 20;
  static const EdgeInsets defaultScaffoldBodyPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets inputFieldContentPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 18);
  static const double defaultShadowColorOpacity = 0.12;
  static const double corouselViewFraction = 0.65;
  static const int POSTER_ASPECT_RATIO_WIDTH = 16;
  static const int POSTER_ASPECT_RATIO_HEIGHT = 9;

  /// Device MediaQuery Data
  late MediaQueryData mediaQueryData;

  void init(BuildContext context) {
    if (!_isInitialized) {
      mediaQueryData = MediaQuery.of(context);
      // set initialized
      _isInitialized = true;
    }
  }

  Size get size {
    return mediaQueryData.size;
  }

  double get screenHeight {
    return size.height;
  }

  double get screenWidth {
    return size.width;
  }

  /// Get [percentage] height of screen
  double percentageScreenHeight(double percent) {
    return screenHeight * percent * 0.01;
  }

  /// Get [percentage] width of screen
  double percentageScreenWidth(double percent) {
    return screenWidth * percent * 0.01;
  }

  double get flexibleAppBarHeight {
    return percentageScreenHeight(15);
  }

  double get appBarHeight {
    return percentageScreenHeight(7.5);
  }

  double get flexibleAppBarShortHeight {
    return percentageScreenHeight(10);
  }

  static const double appBarIconSize = 19;
  static const double defaultIconSize = 17;
  static const double largeIconSize = 24;

  static const double defaultCardElevation = 12;
  static const double defaultButtonElevation = 12;
}
