import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangePhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Phone Number"),
      ),
      body: Body(),
    );
  }
}
