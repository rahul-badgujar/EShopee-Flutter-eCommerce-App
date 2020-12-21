import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
    BuildContext context, String messege) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(messege),
        actions: [
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text("No"),
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
