import 'package:flutter/material.dart';
import 'components/body.dart';
import 'components/home_screen_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_NAME = "/home-screen";

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
      drawer: HomeScreenDrawer(),
    );
  }
}
