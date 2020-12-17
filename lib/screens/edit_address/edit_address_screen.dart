import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class EditAddressScreen extends StatelessWidget {
  final Address addressToEdit;

  const EditAddressScreen({Key key, this.addressToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addressToEdit == null ? "Add New Address" : "Edit Address"),
      ),
      body: Body(addressToEdit: addressToEdit),
    );
  }
}
