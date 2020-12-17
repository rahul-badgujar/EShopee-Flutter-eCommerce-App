import 'package:flutter/material.dart';

import 'components/body.dart';

class AddNewAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Address"),
      ),
      body: Body(),
    );
  }
}
