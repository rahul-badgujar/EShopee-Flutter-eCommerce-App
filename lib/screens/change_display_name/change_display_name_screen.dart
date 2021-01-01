import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangeDisplayNameScreen extends StatelessWidget {
  //TODO: setState being called before build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
