import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuffixIcon extends StatelessWidget {
  final String svgIcon;
  const CustomSuffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        Dimens.instance.percentageScreenWidth(2),
        Dimens.instance.percentageScreenWidth(2),
        Dimens.instance.percentageScreenWidth(2),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: Dimens.instance.percentageScreenWidth(2),
      ),
    );
  }
}
