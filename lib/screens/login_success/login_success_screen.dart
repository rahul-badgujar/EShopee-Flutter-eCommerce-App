import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatelessWidget {
  static const String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Success"),
      ),
    );
  }
}
