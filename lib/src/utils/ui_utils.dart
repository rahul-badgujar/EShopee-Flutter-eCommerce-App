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
        content: Text(messege),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            child: Text(
              positiveResponse,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: Text(
              negativeResponse,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );

  return result ?? false;
}
