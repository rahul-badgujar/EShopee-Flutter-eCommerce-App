import 'package:eshopee/src/components/no_account_text.dart';
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
                SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                Text(
                  "Welcome Back",
                  style:
                      PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
                ),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                  style: PrimaryLightTheme.instance.textTheme
                      .getSubHeaderTextStyle(),
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                const SignInForm(),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                const NoAccountText(),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
