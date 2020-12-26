import 'package:flutter/material.dart';
import 'components/body.dart';

// TODO: Feature-> give items count feature
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Body(),
    );
  }
}
