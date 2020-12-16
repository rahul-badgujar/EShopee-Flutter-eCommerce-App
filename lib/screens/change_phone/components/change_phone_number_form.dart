import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class ChangePhoneNumberForm extends StatefulWidget {
  const ChangePhoneNumberForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangePhoneNumberFormState createState() => _ChangePhoneNumberFormState();
}

class _ChangePhoneNumberFormState extends State<ChangePhoneNumberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPhoneNumberController =
      TextEditingController();
  final TextEditingController currentPhoneNumberController =
      TextEditingController();

  @override
  void dispose() {
    newPhoneNumberController.dispose();
    currentPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Send OTP",
            press: updateUserPhoneNumber,
          ),
        ],
      ),
    );
    currentPhoneNumberController.text =
        AuthentificationService().currentUser.phoneNumber;
    return form;
  }

  void updateUserPhoneNumber() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // TODO: fix implementation update phone service

      final authService = AuthentificationService().firebaseAuth;
      print("Update Phone request for ${authService.currentUser.email} ...");
      try {
        print("Calling verifyPhoneNumber()");
        final verificationCompleteCallback = (credential) async {
          print("Inside verificationCompleted()");
        };
        final verificationFailedCallback = (exception) {
          print("Inside verificationFailed()");
          if (exception.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            print(
                "Exception received in verificationFailed: ${exception.code}");
          }
        };
        final codeSentCallback = (verificationId, resendToken) async {
          print("Inside codeSent() -> verificationId: $verificationId");
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: "666666",
          );
          await authService.currentUser.updatePhoneNumber(phoneAuthCredential);
        };
        final codeAutoRetrivalTimeoutCallback = (verificationId) {
          print(
              "Inside codeAutoRetrievalTimeout() -> verificationId: $verificationId");
        };
        authService.verifyPhoneNumber(
          phoneNumber: newPhoneNumberController.text,
          verificationCompleted: verificationCompleteCallback,
          verificationFailed: verificationFailedCallback,
          codeSent: codeSentCallback,
          codeAutoRetrievalTimeout: codeAutoRetrivalTimeoutCallback,
        );
      } catch (e) {
        print("Exception: $e");
      }
    }
  }

  Widget buildNewPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter New Phone Number",
        labelText: "New Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Phone Number cannot be empty";
        } else if (value[0] != "+") {
          return "Add Country Code with + sign";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      decoration: InputDecoration(
        hintText: "No Phone Number available",
        labelText: "Current Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      readOnly: true,
    );
  }
}
