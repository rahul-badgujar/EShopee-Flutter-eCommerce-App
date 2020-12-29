import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/screens/home/home_screen.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Image.asset(
              "assets/images/success.png",
              height: SizeConfig.screenHeight * 0.4,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Text(
              "Login Success",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "Back to Home",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
