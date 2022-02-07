import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:flutter/material.dart';

class ChangeDisplayNameForm extends StatefulWidget {
  const ChangeDisplayNameForm({
    Key? key,
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
  void initState() {
    AuthService().userChanges.listen((user) {
      if (user != null) {
        currentDisplayNameController.text = user.displayName ?? '';
      }
    });
    super.initState();
  }

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
          SizedBox(height: Dimens.instance.percentageScreenHeight(10)),
          buildCurrentDisplayNameField(),
          SizedBox(height: Dimens.instance.percentageScreenHeight(5)),
          buildNewDisplayNameField(),
          SizedBox(height: Dimens.instance.percentageScreenHeight(20)),
          DefaultButton(
            label: "Change Display Name",
            onPressed: () async {
              final uploadFuture = changeDisplayNameButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return AsyncProgressDialog(
                    uploadFuture,
                    message: const Text("Updating Display Name"),
                  );
                },
              );
              showTextSnackbar(context, "Display Name updated");
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
      decoration: const InputDecoration(
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
    return TextFormField(
      controller: currentDisplayNameController,
      decoration: const InputDecoration(
        hintText: "No Display Name available",
        labelText: "Current Display Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
      readOnly: true,
    );
  }

  Future<void> changeDisplayNameButtonCallback() async {
    final formState = _formKey.currentState;

    if (formState == null) {
      throw Exception('Could not evaluate Form State.');
    }
    if (formState.validate()) {
      formState.save();
      await AuthService()
          .updateCurrentUserDisplayName(newDisplayNameController.text);
      //print("Display Name updated to ${newDisplayNameController.text} ...");
    }
  }
}
