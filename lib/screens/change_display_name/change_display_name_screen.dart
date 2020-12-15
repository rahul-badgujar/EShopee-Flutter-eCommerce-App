import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangeDisplayNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Display Name"),
      ),
      body: Body(),
    );
  }
}
