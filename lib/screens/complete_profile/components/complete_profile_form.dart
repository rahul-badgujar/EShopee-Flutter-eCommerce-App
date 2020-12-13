import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/screens/otp/otp_screen.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String firstname;
  String lastname;
  String phoneNumber;
  String address;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstnameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastnameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                // goto OTP Screen
                Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter your address",
        labelText: "Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Location point.svg",
        ),
      ),
      onChanged: (value) {
        address = value;
        if (value.isNotEmpty) {
          return kAddressNullError;
        }
        return null;
      },
      validator: (value) {
        address = value;
        if (value.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
      onSaved: (newValue) => address = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter your phone number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Phone.svg",
        ),
      ),
      onChanged: (value) {
        phoneNumber = value;
        if (value.isNotEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
      validator: (value) {
        phoneNumber = value;
        if (value.isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
      onSaved: (newValue) => phoneNumber = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLastnameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter your last name",
        labelText: "Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User.svg",
        ),
      ),
      onChanged: (value) {
        lastname = value;
        if (value.isNotEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      validator: (value) {
        lastname = value;
        if (value.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      onSaved: (newValue) => lastname = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildFirstnameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter your first name",
        labelText: "First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User.svg",
        ),
      ),
      onChanged: (value) {
        firstname = value;
        if (value.isNotEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      validator: (value) {
        firstname = value;
        if (value.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      onSaved: (newValue) => firstname = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
