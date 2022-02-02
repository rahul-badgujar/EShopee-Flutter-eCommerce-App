import 'package:eshopee/src/components/icon_button_with_counter.dart';
import 'package:eshopee/src/components/rounded_icon_button.dart';
import 'package:eshopee/src/components/search_field.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final void Function(String) onSearchSubmitted;
  final void Function() onCartButtonPressed;
  const HomeHeader({
    Key? key,
    required this.onSearchSubmitted,
    required this.onCartButtonPressed,
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
        Expanded(
          child: SearchField(
            onSubmit: onSearchSubmitted,
          ),
        ),
        const SizedBox(width: 5),
        IconButtonWithCounter(
          svgSrc: "assets/icons/Cart Icon.svg",
          numOfItems: 0,
          press: onCartButtonPressed,
        ),
      ],
    );
  }
}
