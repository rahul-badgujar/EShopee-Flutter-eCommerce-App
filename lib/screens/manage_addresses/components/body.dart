import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/nothingtoshow_container.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/screens/edit_address/edit_address_screen.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../components/address_box.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: UserDatabaseHelper().currentUserAddressesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final addresses = snapshot.data.docs
                        .map((e) => Address.fromMap(e.data(), id: e.id))
                        .toList();
                    if (addresses.length == 0) {
                      return Center(
                        child: NothingToShowContainer(
                          iconPath: "assets/icons/add_location.svg",
                          secondaryMessage: "Add your first Address",
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) => AddressBox(
                        address: addresses[index],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    final error = snapshot.error;
                    Logger().w(error.toString());
                  }
                  return Center(
                    child: NothingToShowContainer(
                      iconPath: "assets/icons/network_error.svg",
                      primaryMessage: "Something went wrong",
                      secondaryMessage: "Unable to connect to Database",
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      ),
    );
  }
}
