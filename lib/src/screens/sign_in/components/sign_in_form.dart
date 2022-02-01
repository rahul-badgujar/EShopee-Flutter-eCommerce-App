import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/custom_suffix_icon.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/screens/forgot_password/forgot_password_screen.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();

  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
          buildPasswordFormField(),
          SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
          buildForgotPasswordWidget(context),
          SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
          DefaultButton(
            label: "Sign in",
            onPressed: signInButtonCallback,
          ),
        ],
      ),
    );
  }

  Widget buildForgotPasswordWidget(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.restorablePushNamed(
                context, ForgotPasswordScreen.ROUTE_NAME);
          },
          child: const Text(
            "Forgot Password",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
          padding: EdgeInsets.fromLTRB(
            0,
            Dimens.instance.percentageScreenWidth(2.8),
            Dimens.instance.percentageScreenWidth(1),
            Dimens.instance.percentageScreenWidth(2.8),
          ),
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

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
          padding: EdgeInsets.fromLTRB(
            0,
            Dimens.instance.percentageScreenWidth(3.8),
            Dimens.instance.percentageScreenWidth(1),
            Dimens.instance.percentageScreenWidth(3.8),
          ),
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

  Future<void> signInButtonCallback() async {
    final formCurrentState = _formkey.currentState;
    if (formCurrentState == null) {
      throw Exception('Could not evaluate Form State.');
    }
    if (formCurrentState.validate()) {
      formCurrentState.save();

      // to save exception if any occured
      dynamic exceptionOccured;

      final signInFuture = AuthService().signIn(
        email: emailFieldController.text.trim(),
        password: passwordFieldController.text.trim(),
      );
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            signInFuture,
            message: const Text("Signing in to account"),
            onError: (e) {
              exceptionOccured = e;
            },
          );
        },
      );
      if (exceptionOccured == null) {
        // login succcessful
        showTextSnackbar(context, 'Signed in successfully');
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
