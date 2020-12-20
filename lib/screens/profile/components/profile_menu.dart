import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback press;
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color(0xFFF5F6F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.all(20),
      onPressed: press,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 22,
            color: kPrimaryColor,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: kTextColor,
          ),
        ],
      ),
    );
  }
}
