import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/nothingtoshow_container.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/screens/edit_address/edit_address_screen.dart';
import 'package:e_commerce_app_flutter/services/data_streams/addresses_stream.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../components/address_box.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AddressesStream addressesStream = AddressesStream();

  @override
  void initState() {
    super.initState();
    addressesStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    addressesStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
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
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: StreamBuilder<List<String>>(
                      stream: addressesStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final addresses = snapshot.data;
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
                              addressId: addresses[index],
                              deleteButtonCallback: deleteButtonCallback,
                              editButtonCallback: editButtonCallback,
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
                  SizedBox(height: getProportionateScreenHeight(50)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    addressesStream.reload();
    return Future<void>.value();
  }

  Future<void> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this Address ?"),
          actions: [
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (confirmDeletion) {
      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().deleteAddressForCurrentUser(addressId);
        if (status == true) {
          snackbarMessage = "Address deleted successfully";
        } else {
          throw "Coulnd't delete address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
      await refreshPage();
    }
  }

  void editButtonCallback(BuildContext context, String addressId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditAddressScreen(addressIdToEdit: addressId))).then(
      (_) async {
        await refreshPage();
      },
    );
  }
}
