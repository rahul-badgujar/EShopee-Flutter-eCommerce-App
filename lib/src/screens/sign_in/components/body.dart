import 'package:eshopee/src/resources/themes/ui_themes.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';

import 'sign_in_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: Dimens.defaultScaffoldBodyPadding,
          child: SingleChildScrollView(
            physics: Constants.appWideScrollablePhysics,
            child: Column(
              children: [
                SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                const SignInForm(),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                buildNoAccountText(context),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoAccountText(BuildContext context) {
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
            Navigator.restorablePopAndPushNamed(context, '');
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
