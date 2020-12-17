import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/screens/edit_address/edit_address_screen.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../components/address_box.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Manage Addresses",
                style: headingStyle,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              DefaultButton(
                text: "Add New Address",
                press: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAddressScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              StreamBuilder(
                stream: UserDatabaseHelper().currentUserAddressesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final addresses = snapshot.data.docs
                        .map((e) => Address.fromMap(e.data(), id: e.id))
                        .toList();
                    return Column(
                      children: List.generate(
                        addresses.length,
                        (index) => AddressBox(
                          address: addresses[index],
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],
          ),
        ),
      ),
    );
  }
}
