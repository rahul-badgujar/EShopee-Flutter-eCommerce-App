import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';

import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChangeEmailForm extends StatefulWidget {
  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    currentEmailController.dispose();
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            buildCurrentEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildNewEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            DefaultButton(
              text: "Change Email",
              press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // TODO: user data reload
                  final AuthentificationService authService =
                      AuthentificationService();
                  bool passwordValidation = await authService
                      .verifyCurrentUserPassword(passwordController.text);
                  if (passwordValidation) {
                    String updationStatus =
                        await authService.changeEmailForCurrentUser(
                            newEmail: newEmailController.text);
                    if (updationStatus ==
                        AuthentificationService.EMAIL_UPDATE_SUCCESSFULL) {
                      print(
                          "Email updation action triggered, verify email to change");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Verification Email sent, Please verify new email")));
                    } else if (updationStatus ==
                        AuthentificationService.WRONG_PASSWORD) {
                      print("Wrong password...");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Wrong Password")));
                    } else {
                      print("Exception result: $updationStatus");
                    }
                  } else {
                    print("Entered password is wrong...");
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Something went wrong")));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
    currentEmailController.text = AuthentificationService().currentUser.email;
    return form;
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        labelText: "Enter Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return TextFormField(
      controller: currentEmailController,
      decoration: InputDecoration(
        hintText: "CurrentEmail",
        labelText: "Current Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      readOnly: true,
    );
  }

  Widget buildNewEmailFormField() {
    return TextFormField(
      controller: newEmailController,
      decoration: InputDecoration(
        hintText: "Enter New Email",
        labelText: "New Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        } else if (value == currentEmailController.text) {
          return "Email is already linked to account";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
