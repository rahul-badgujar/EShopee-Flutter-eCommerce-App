import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangeDisplayPictureScreen extends StatelessWidget {
  static const ROUTE_NAME = '/change-display-picture-screen';

  const ChangeDisplayPictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
