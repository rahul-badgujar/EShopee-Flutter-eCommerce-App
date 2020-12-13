import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text(
                "We sent your code to +91 ********53",
                textAlign: TextAlign.center,
              ),
              buildTimer(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // TODO: add resend OTP code here
                },
                child: Text(
                  "Resent OTP Code",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will epxire in "),
        TweenAnimationBuilder(
          tween: IntTween(begin: 30, end: 0),
          duration: Duration(seconds: 30),
          builder: (context, value, child) => Text(
            "00:$value",
            style: TextStyle(color: kPrimaryColor),
          ),
          onEnd: () {},
        ),
      ],
    );
  }
}
