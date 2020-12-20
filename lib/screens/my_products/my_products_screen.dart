import 'package:flutter/material.dart';
import 'components/body.dart';

class MyProductsScreen extends StatelessWidget {
  static const String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Your Products"),
      ),
      body: Body(),
      //body: Body(),
    );
  }
}
