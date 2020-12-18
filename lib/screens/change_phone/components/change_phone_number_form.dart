import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
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
            text: "Update Phone Number",
            press: updatePhoneNumberButtonCallback,
          ),
        ],
      ),
    );
    UserDatabaseHelper().currentUserPhoneNumber.then((value) {
      if (value != null) currentPhoneNumberController.text = value;
    });

    return form;
  }

  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String status = await UserDatabaseHelper()
          .updatePhoneForCurrentUser(newPhoneNumberController.text);
      if (status == UserDatabaseHelper.PHONE_UPDATED_SUCCESSFULLY) {
        print("Phone Number updated successfully");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone Number updated successfully")));
        Navigator.pop(context);
      } else {
        print("Exception Result: $status");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
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
        suffixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (newPhoneNumberController.text.isEmpty) {
          return "Phone Number cannot be empty";
        } else if (newPhoneNumberController.text.length != 10) {
          return "Only 10 digits allowed";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return TextFormField(
      controller: currentPhoneNumberController,
      decoration: InputDecoration(
        hintText: "No Phone Number available",
        labelText: "Current Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
      readOnly: true,
    );
  }
}
