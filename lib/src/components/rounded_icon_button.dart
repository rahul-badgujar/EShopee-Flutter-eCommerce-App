import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback press;
  const RoundedIconButton({
    Key? key,
    required this.iconData,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.instance.percentageScreenWidth(4),
      width: Dimens.instance.percentageScreenWidth(4),
      child: TextButton(
        onPressed: press,
        child: Icon(
          iconData,
          color: UiPalette.textDarkShade(3),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
    );
  }
}
