import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/screens/edit_address/edit_address_screen.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key key,
    @required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kTextColor.withOpacity(0.025),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(
                  color: kTextColor.withOpacity(0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.title}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${address.receiver}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${address.addresLine1}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${address.addressLine2}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "City: ${address.city}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "District: ${address.district}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "State: ${address.state}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Landmark: ${address.landmark}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "PIN: ${address.pincode}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Phone: ${address.phone}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    editButtonCallback(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    deleteButtonCallback(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteButtonCallback(BuildContext context) async {
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
      String status =
          await UserDatabaseHelper().deleteAddressForCurrentUser(address.id);
      if (status == UserDatabaseHelper.ADDRESS_DELETED_SUCCESSFULLY) {
        print("Address deleted successfully");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Address deleted successfully")));
      } else {
        print("Result Exception: $status");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong...")));
      }
    }
  }

  void editButtonCallback(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAddressScreen(addressToEdit: address)));
  }
}
