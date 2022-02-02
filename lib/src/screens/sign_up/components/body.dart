import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

import 'sign_up_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: Constants.appWideScrollablePhysics,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
              Text(
                "Register Account",
                style:
                    PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
              ),
              Text(
                "Complete your details or continue \nwith social media",
                textAlign: TextAlign.center,
                style: PrimaryLightTheme.instance.textTheme
                    .getSubHeaderTextStyle(),
              ),
              SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
              const SignUpForm(),
              SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
              Text(
                "By continuing your confirm that you agree \nwith our Terms and Conditions",
                textAlign: TextAlign.center,
                style: PrimaryLightTheme.instance.textTheme
                    .getSubHeaderTextStyle(),
              ),
              SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
            ],
          ),
        ),
      ),
    );
  }
}
