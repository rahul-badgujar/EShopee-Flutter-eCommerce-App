import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'change_display_name_form.dart';

class Body extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "Change Display Name",
              style: headingStyle,
            ),
            ChangeDisplayNameForm(),
          ],
        ),
      ),
    );
  }
}
