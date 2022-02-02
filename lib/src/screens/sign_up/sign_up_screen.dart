import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/sign-up-screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //appBar: AppBar(),
      body: Body(),
    );
  }
}
