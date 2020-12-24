import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import '../../../size_config.dart';

class ChangeDisplayNameForm extends StatefulWidget {
  const ChangeDisplayNameForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangeDisplayNameFormState createState() => _ChangeDisplayNameFormState();
}

class _ChangeDisplayNameFormState extends State<ChangeDisplayNameForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newDisplayNameController =
      TextEditingController();

  final TextEditingController currentDisplayNameController =
      TextEditingController();

  @override
  void dispose() {
    newDisplayNameController.dispose();
    currentDisplayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentDisplayNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewDisplayNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Change Display Name",
            press: () {
              final uploadFuture = changeDisplayNameButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    uploadFuture,
                    message: Text("Updating Display Name"),
                  );
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Display Name updated")));
            },
          ),
        ],
      ),
    );

    return form;
  }

  Widget buildNewDisplayNameField() {
    return TextFormField(
      controller: newDisplayNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter New Display Name",
        labelText: "New Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (newDisplayNameController.text.isEmpty) {
          return "Display Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String displayName;
        if (snapshot.hasData && snapshot.data != null)
          displayName = snapshot.data.displayName;
        final textField = TextFormField(
          controller: currentDisplayNameController,
          decoration: InputDecoration(
            hintText: "No Display Name available",
            labelText: "Current Display Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          readOnly: true,
        );
        if (displayName != null)
          currentDisplayNameController.text = displayName;
        return textField;
      },
    );
  }

  Future<void> changeDisplayNameButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await AuthentificationService()
          .updateCurrentUserDisplayName(newDisplayNameController.text);
      print("Display Name updated to ${newDisplayNameController.text} ...");
    }
  }
}
