import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import 'address_details_form.dart';

class Body extends StatelessWidget {
  final Address addressToEdit;

  const Body({Key key, this.addressToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                "Fill Address Details",
                style: headingStyle,
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              AddressDetailsForm(addressToEdit: addressToEdit),
              SizedBox(height: getProportionateScreenHeight(40)),
            ],
          ),
        ),
      ),
    );
  }
}
