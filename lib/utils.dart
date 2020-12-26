import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
  BuildContext context,
  String messege, {
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(messege),
        actions: [
          FlatButton(
            child: Text(positiveResponse),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text(negativeResponse),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
  if (result == null) result = false;
  return result;
}
