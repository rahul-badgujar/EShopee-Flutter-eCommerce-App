import 'package:eshopee/src/components/no_account_text.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

import 'forgot_password_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: Constants.appWideScrollablePhysics,
        child: Padding(
          padding: Dimens.defaultScaffoldBodyPadding,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                Text(
                  "Forgot Password",
                  style:
                      PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
                ),
                Text(
                  "Please enter your email and we will send \nyou a link to return to your account",
                  textAlign: TextAlign.center,
                  style: PrimaryLightTheme.instance.textTheme
                      .getSubHeaderTextStyle(),
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                const ForgotPasswordForm(),
                SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
                const NoAccountText(),
                SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
