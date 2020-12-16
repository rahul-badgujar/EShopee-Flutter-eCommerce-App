import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Email"),
      ),
      body: Body(),
    );
  }
}
