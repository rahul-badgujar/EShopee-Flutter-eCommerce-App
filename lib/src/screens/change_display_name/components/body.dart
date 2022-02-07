import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';
import 'change_display_name_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: Constants.appWideScrollablePhysics,
      child: Padding(
        padding: Dimens.defaultScaffoldBodyPadding,
        child: Column(
          children: [
            SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
            Text(
              "Change Display Name",
              style: PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
            ),
            const ChangeDisplayNameForm(),
          ],
        ),
      ),
    );
  }
}
