import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            buildCurrentPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildNewPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildConfirmNewPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            DefaultButton(
              text: "Change Password",
              press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  final AuthentificationService authService =
                      AuthentificationService();
                  bool currentPasswordValidation =
                      await authService.verifyCurrentUserPassword(
                          currentPasswordController.text);
                  if (currentPasswordValidation == false) {
                    print("Current password provided is wrong");
                  } else {
                    final String updationStatus =
                        await authService.changePasswordForCurrentUser(
                            newPassword: newPasswordController.text);
                    if (updationStatus ==
                        AuthentificationService.PASSWORD_UPDATE_SUCCESSFULL) {
                      print("Password updated successfully...");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Updated Password")));
                    } else if (updationStatus ==
                        AuthentificationService.WEAK_PASSWORD) {
                      print("Password is weak");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Password is too weak, try something better")));
                    } else {
                      print("Exception result: $updationStatus");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Something went wrong")));
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmNewPasswordFormField() {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        labelText: "Confirm New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (value != newPasswordController.text) {
          return "Not matching with Password";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPasswordFormField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter Current Password",
        labelText: "Current Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }

  Widget buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter New password",
        labelText: "New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Password cannot be empty";
        } else if (value.length < 8) {
          return "Password too short";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
