import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/custom_suffix_icon.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
          DefaultButton(
            label: "Send verification email",
            onPressed: sendVerificationEmailButtonCallback,
          ),
        ],
      ),
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

  Future<void> sendVerificationEmailButtonCallback() async {
    final formCurrentState = _formKey.currentState;
    if (formCurrentState == null) {
      throw Exception('Could not evaluate Form State.');
    }
    if (formCurrentState.validate()) {
      formCurrentState.save();

      // to save exception if any occured
      dynamic exceptionOccured;

      final emailInput = emailFieldController.text.trim();
      final signInFuture = AuthService().resetPasswordForEmail(emailInput);
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
        showTextSnackbar(context, "Password Reset Link sent to your email");
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
