import 'package:flutter/material.dart';

void showTextSnackbar(BuildContext context, String text, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration ?? const Duration(seconds: 1, milliseconds: 500),
    ),
  );
}
