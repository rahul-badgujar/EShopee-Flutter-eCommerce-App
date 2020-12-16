import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController displayNameEditController =
      TextEditingController();
  final TextEditingController phoneNumberEditController =
      TextEditingController();

  User currentUser;

  @override
  void initState() {
    currentUser = AuthentificationService().currentUser;
    super.initState();
  }

  @override
  void dispose() {
    emailEditController.dispose();
    displayNameEditController.dispose();
    phoneNumberEditController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Form form = Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDisplayNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Save",
            press: () {
              if (_formKey.currentState.validate()) {
                // goto OTP Screen
                saveProfileDetails();
              }
            },
          ),
        ],
      ),
    );
    print("Fill profile details for ${currentUser.email}");
    emailEditController.text = currentUser.email;
    displayNameEditController.text = currentUser.displayName;
    phoneNumberEditController.text = currentUser.phoneNumber;
    return form;
  }

  Widget buildPhoneNumberFormField() {
    return TextFormField(
      controller: phoneNumberEditController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter your phone number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Phone.svg",
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDisplayNameFormField() {
    return TextFormField(
      controller: displayNameEditController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter your display name",
        labelText: "Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User.svg",
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your Display Name";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailEditController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User.svg",
        ),
      ),
      readOnly: true,
    );
  }

  void saveProfileDetails() {
    currentUser.updateProfile(
      displayName: displayNameEditController.text,
    );
    print("Updated User's DisplayName");
  }
}
