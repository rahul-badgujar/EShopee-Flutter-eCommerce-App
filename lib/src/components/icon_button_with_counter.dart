import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonWithCounter extends StatelessWidget {
  final String svgSrc;
  final int numOfItems;
  final GestureTapCallback press;
  const IconButtonWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfItems = 0,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior:
            Clip.none, // makes the stack clip over the overlapping widget
        children: [
          Container(
            padding: EdgeInsets.all(Dimens.instance.percentageScreenWidth(2.8)),
            width: Dimens.instance.percentageScreenWidth(12),
            height: Dimens.instance.percentageScreenWidth(12),
            decoration: BoxDecoration(
              color: UiPalette.secondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItems >= 0)
            Positioned(
              right: 0,
              top: -3,
              child: Container(
                width: Dimens.instance.percentageScreenWidth(5),
                height: Dimens.instance.percentageScreenWidth(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      fontSize: Dimens.instance.percentageScreenWidth(2),
                      color: Colors.white,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
