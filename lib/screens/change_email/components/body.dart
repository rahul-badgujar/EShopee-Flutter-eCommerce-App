import 'package:e_commerce_app_flutter/constants.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import '../components/change_email_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Change Email",
                  style: headingStyle,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                ChangeEmailForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
