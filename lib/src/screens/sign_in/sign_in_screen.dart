import 'package:flutter/material.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static const ROUTE_NAME = '/sign-in-screen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(),
      body: Body(),
    );
  }
}
