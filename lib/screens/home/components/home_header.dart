import 'package:e_commerce_app_flutter/components/rounded_icon_button.dart';
import 'package:e_commerce_app_flutter/components/search_field.dart';
import 'package:e_commerce_app_flutter/screens/cart/cart_screen.dart';
import 'package:e_commerce_app_flutter/screens/search_result/search_result_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import '../../../components/icon_button_with_counter.dart';

class HomeHeader extends StatelessWidget {
  final Function onSearchSubmitted;
  const HomeHeader({
    Key key,
    @required this.onSearchSubmitted,
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
        SizedBox(width: 5),
        IconButtonWithCounter(
          svgSrc: "assets/icons/Cart Icon.svg",
          numOfItems: 0,
          press: () async {
            bool allowed = AuthentificationService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend verification email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future = AuthentificationService()
                    .sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      future,
                      message: Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ));
          },
        ),
      ],
    );
  }
}
