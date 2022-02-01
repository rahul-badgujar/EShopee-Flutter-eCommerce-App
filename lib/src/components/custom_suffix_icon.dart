import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  final String svgIcon;
  const CustomSuffixIcon({
    Key? key,
    required this.padding,
    required this.svgIcon,
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SvgPicture.asset(
        svgIcon,
        // height: Dimens.instance.percentageScreenWidth(1),
      ),
    );
  }
}
