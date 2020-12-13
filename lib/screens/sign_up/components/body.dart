import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/screens/sign_up/components/sign_up_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "Register Account",
            style: headingStyle,
          ),
          Text(
            "Complete your details or continue \nwith social media",
            textAlign: TextAlign.center,
          ),
          SignUpForm(),
        ],
      ),
    );
  }
}
