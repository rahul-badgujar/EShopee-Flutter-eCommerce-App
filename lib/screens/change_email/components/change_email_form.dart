import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

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
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
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
              press: () {
                final updateFuture = changeEmailButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      updateFuture,
                      message: Text("Updating Email"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );

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
        if (passwordController.text.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String currentEmail;
        if (snapshot.hasData && snapshot.data != null)
          currentEmail = snapshot.data.email;
        final textField = TextFormField(
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
        if (currentEmail != null) currentEmailController.text = currentEmail;
        return textField;
      },
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
        if (newEmailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmailController.text)) {
          return kInvalidEmailError;
        } else if (newEmailController.text == currentEmailController.text) {
          return "Email is already linked to account";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changeEmailButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      bool passwordValidation =
          await authService.verifyCurrentUserPassword(passwordController.text);
      if (passwordValidation) {
        bool updationStatus = false;
        String snackbarMessage;
        try {
          updationStatus = await authService.changeEmailForCurrentUser(
              newEmail: newEmailController.text);
          if (updationStatus == true) {
            snackbarMessage =
                "Verification email sent. Please verify your new email";
          } else {
            throw FirebaseCredentialActionAuthUnknownReasonFailureException(
                message:
                    "Couldn't process your request now. Please try again later");
          }
        } on MessagedFirebaseAuthException catch (e) {
          snackbarMessage = e.message;
        } catch (e) {
          snackbarMessage = e.toString();
        } finally {
          Logger().i(snackbarMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarMessage),
            ),
          );
        }
      }
    }
  }
}
