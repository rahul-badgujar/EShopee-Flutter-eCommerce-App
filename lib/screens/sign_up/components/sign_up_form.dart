import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildConfirmPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            DefaultButton(
              text: "Continue",
              press: () async {
                if (_formKey.currentState.validate()) {
                  // goto complete profile page
                  final AuthentificationService authService =
                      AuthentificationService();
                  String signUpStatus = await authService.signUp(
                    email: email,
                    password: password,
                  );
                  if (signUpStatus ==
                      AuthentificationService.SIGN_UP_SUCCESS_MSG) {
                    print("Sign Up succesfull, try signing in");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                  } else if (signUpStatus ==
                      AuthentificationService.EMAIL_ALREADY_IN_USE) {
                    print("Email already in use, try different email");
                  } else {
                    print("Exception result: $signUpStatus");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      onChanged: (value) {
        confirmPassword = value;
        if (value.isNotEmpty) {
          return kPassNullError;
        } else if (password == confirmPassword) {
          return kMatchPassError;
        } else if (value.length >= 8) {
          return kShortPassError;
        }
        return null;
      },
      validator: (value) {
        confirmPassword = value;
        if (value.isEmpty) {
          return kPassNullError;
        } else if (password != confirmPassword) {
          return kMatchPassError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      onSaved: (newValue) => confirmPassword = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      onChanged: (value) {
        email = value;
        password = value;
        if (value.isNotEmpty) {
          return kEmailNullError;
        } else if (emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      validator: (value) {
        email = value;
        if (value.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      onSaved: (newValue) => email = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      onChanged: (value) {
        password = value;
        if (value.isNotEmpty) {
          return kPassNullError;
        } else if (value.length >= 8) {
          return kShortPassError;
        }
        return null;
      },
      validator: (value) {
        password = value;
        if (value.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      onSaved: (newValue) => password = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
