import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductTypeBox extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPress;
  const ProductTypeBox({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: kPrimaryColor.withOpacity(0.18),
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
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenHeight(8),
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
