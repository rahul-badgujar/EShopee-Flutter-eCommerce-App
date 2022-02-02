import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key? key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "Nothing to show",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.instance.percentageScreenWidth(75),
      height: Dimens.instance.percentageScreenHeight(20),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            color: UiPalette.textDarkShade(3),
            width: Dimens.instance.percentageScreenWidth(7),
          ),
          const SizedBox(height: 16),
          Text(
            primaryMessage,
            style: TextStyle(
              color: UiPalette.textDarkShade(3),
              fontSize: 15,
            ),
          ),
          Text(
            secondaryMessage,
            style: TextStyle(
              color: UiPalette.textDarkShade(3),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
