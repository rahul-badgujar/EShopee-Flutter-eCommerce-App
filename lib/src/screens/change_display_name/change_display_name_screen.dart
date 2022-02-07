import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangeDisplayNameScreen extends StatelessWidget {
  static const ROUTE_NAME = '/change-display-name-screen';

  const ChangeDisplayNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
