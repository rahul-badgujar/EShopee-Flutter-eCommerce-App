import 'package:flutter/material.dart';
import 'components/body.dart';

class ManageAddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Addresses"),
      ),
      body: Body(),
    );
  }
}
