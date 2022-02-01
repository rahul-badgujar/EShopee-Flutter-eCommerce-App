import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  final String svgIcon;
  const CustomSuffixIcon({
    Key? key,
    this.padding,
    required this.svgIcon,
  }) : super(key: key);

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.fromLTRB(
            0,
            Dimens.instance.percentageScreenWidth(2.8),
            Dimens.instance.percentageScreenWidth(1),
            Dimens.instance.percentageScreenWidth(2.8),
          ),
      child: SvgPicture.asset(
        svgIcon,
        // height: Dimens.instance.percentageScreenWidth(1),
      ),
    );
  }
}
