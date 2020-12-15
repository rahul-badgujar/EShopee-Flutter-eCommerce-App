import 'package:e_commerce_app_flutter/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_suffix_icon.dart';
import '../../../components/default_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();

  String email;
  String password;
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ));
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formkey.currentState.validate()) {
                _formkey.currentState.save();
                context.read<AuthentificationService>().signIn(
                      email: email.trim(),
                      password: password.trim(),
                    );
              }
            },
          ),
        ],
      ),
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
}
