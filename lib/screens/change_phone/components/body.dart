import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'change_phone_number_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Change Phone Number",
                style: headingStyle,
              ),
              ChangePhoneNumberForm(),
            ],
          ),
        ),
      ),
    );
  }
}
