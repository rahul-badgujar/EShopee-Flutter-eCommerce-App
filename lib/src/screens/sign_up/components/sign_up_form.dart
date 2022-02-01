import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/custom_suffix_icon.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
      TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: Dimens.defaultScaffoldBodyPadding,
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
            buildPasswordFormField(),
            SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
            buildConfirmPasswordFormField(),
            SizedBox(height: Dimens.instance.percentageScreenHeight(7)),
            DefaultButton(
              label: "Sign up",
              onPressed: signUpButtonCallback,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (confirmPasswordFieldController.text.isEmpty) {
          return 'Password cannot be empty';
        } else if (confirmPasswordFieldController.text !=
            passwordFieldController.text) {
          return 'Confirm password is not matching with password';
        } else if (confirmPasswordFieldController.text.length < 8) {
          return 'Password too short, should be atleast 8 characters long';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return 'Email cannot be empty.';
        } else if (!Constants.emailValidatorRegExp
            .hasMatch(emailFieldController.text)) {
          return 'Invalid email.';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return 'Password cannot be empty.';
        } else if (passwordFieldController.text.length < 8) {
          return 'Password too short, should contain atleast 8 characters.';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signUpButtonCallback() async {
    final formCurrentState = _formKey.currentState;
    if (formCurrentState == null) {
      throw Exception('Could not evaluate Form State.');
    }
    if (formCurrentState.validate()) {
      formCurrentState.save();

      // to save exception if any occured
      dynamic exceptionOccured;

      final signUpTask = AuthService().signUp(
        email: emailFieldController.text,
        password: passwordFieldController.text,
      );
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            signUpTask,
            message: const Text("Creating new account"),
            onError: (e) {
              exceptionOccured = e;
            },
          );
        },
      );
      if (exceptionOccured == null) {
        // login succcessful
        showTextSnackbar(
            context, "Registered successfully, Please verify your email id");
        Navigator.pop(context);
      } else {
        if (exceptionOccured is FirebaseAuthException) {
          showTextSnackbar(
              context,
              (exceptionOccured as FirebaseAuthException).message ??
                  'Unknown Firebase Auth Exception occured');
        } else {
          showTextSnackbar(context, exceptionOccured.toString());
        }
      }
    }
  }
}
