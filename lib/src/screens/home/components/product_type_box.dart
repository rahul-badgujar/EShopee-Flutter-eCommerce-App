import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductTypeBox extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPress;
  const ProductTypeBox({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                PrimaryLightTheme.instance.theme.primaryColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: PrimaryLightTheme.instance.theme.primaryColor
                  .withOpacity(0.18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SvgPicture.asset(
                      icon,
                      color: PrimaryLightTheme.instance.theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: PrimaryLightTheme.instance.theme.primaryColor,
                  fontSize: Dimens.instance.percentageScreenHeight(1),
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
