import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: Dimens.instance.percentageScreenWidth(4),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.restorablePushNamed(context, SignUpScreen.ROUTE_NAME);
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: Dimens.instance.percentageScreenWidth(4),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
