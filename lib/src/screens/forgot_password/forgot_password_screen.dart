import 'package:flutter/material.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String ROUTE_NAME = "/forgot-password-screen";

  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: const Body(),
    );
  }
}
