import 'package:e_commerce_app_flutter/components/rounded_icon_button.dart';
import 'package:e_commerce_app_flutter/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../components/search_field.dart';
import '../../../components/icon_button_with_counter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedIconButton(
            iconData: Icons.menu,
            press: () {
              Scaffold.of(context).openDrawer();
            }),
        Expanded(child: SearchField()),
        SizedBox(width: 5),
        IconButtonWithCounter(
          svgSrc: "assets/icons/Cart Icon.svg",
          numOfItems: 0,
          press: () {
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                )); */
          },
        ),
        SizedBox(width: 5),
        IconButtonWithCounter(
          svgSrc: "assets/icons/Bell.svg",
          numOfItems: 3,
          press: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ));
          },
        ),
      ],
    );
  }
}
