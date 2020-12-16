import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  text: "Save",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      AuthentificationService()
                          .updateCurrentUserDisplayName(fieldController.text);
                      print(
                          "Display Name updated to ${fieldController.text} ...");
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
        hintText: "Enter new Display Name",
        labelText: "Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Display Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
