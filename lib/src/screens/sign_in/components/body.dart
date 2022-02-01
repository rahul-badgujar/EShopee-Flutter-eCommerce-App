import 'package:eshopee/src/resources/themes/primary_light/styles/text_styles.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';

import 'sign_in_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

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
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                Text(
                  "Welcome Back",
                  style:
                      PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
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
            // TODO: goto sign up screen
            // Navigator.restorablePopAndPushNamed(context, '');
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
