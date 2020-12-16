import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fieldController = TextEditingController();
  @override
  void dispose() {
    fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: SizeConfig.screenHeight * 0.8,
            child: Column(
              children: [
                Spacer(),
                buildDisplayNameField(),
                Spacer(),
                DefaultButton(
                  text: "Send OTP",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // TODO: fix implementation update phone service
                      final authService =
                          AuthentificationService().firebaseAuth;
                      print(
                          "Update Phone request for ${authService.currentUser.email} ...");
                      try {
                        print("Calling verifyPhoneNumber()");
                        authService.verifyPhoneNumber(
                          phoneNumber: fieldController.text,
                          verificationCompleted: (credential) async {
                            print("Inside verificationCompleted()");
                          },
                          verificationFailed: (exception) {
                            print("Inside verificationFailed()");
                            if (exception.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            } else {
                              print(
                                  "Exception received in verificationFailed: ${exception.code}");
                            }
                          },
                          codeSent: (verificationId, resendToken) async {
                            print(
                                "Inside codeSent() -> verificationId: $verificationId");
                            PhoneAuthCredential phoneAuthCredential =
                                PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: "666666",
                            );
                            await authService.currentUser
                                .updatePhoneNumber(phoneAuthCredential);
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            print(
                                "Inside codeAutoRetrievalTimeout() -> verificationId: $verificationId");
                          },
                        );
                      } catch (e) {
                        print("Exception: $e");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayNameField() {
    return TextFormField(
      controller: fieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter Phone Number",
        labelText: "Phone Number",
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
}
