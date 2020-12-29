import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(50),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                    width: SizeConfig.screenWidth * 0.8,
                    height: SizeConfig.screenHeight * 0.5,
                    child:
                        Image.asset("assets/images/launcher_icon_trans.png")),
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.25,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
