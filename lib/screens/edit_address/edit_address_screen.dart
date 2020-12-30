import 'package:flutter/material.dart';

import 'components/body.dart';

class EditAddressScreen extends StatelessWidget {
  final String addressIdToEdit;

  const EditAddressScreen({Key key, this.addressIdToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
      ),
      body: Body(addressIdToEdit: addressIdToEdit),
    );
  }
}
