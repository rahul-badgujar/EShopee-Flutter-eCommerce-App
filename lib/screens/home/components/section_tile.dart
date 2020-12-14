import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final GestureTapCallback press;
  const SectionTile({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Icon(
            Icons.arrow_forward_ios,
            size: getProportionateScreenWidth(15),
          ),
        ),
      ],
    );
  }
}
