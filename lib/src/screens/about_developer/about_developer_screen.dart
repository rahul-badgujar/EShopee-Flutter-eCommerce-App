import 'package:flutter/material.dart';

import 'components/body.dart';

class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/about-developer-screen';

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
