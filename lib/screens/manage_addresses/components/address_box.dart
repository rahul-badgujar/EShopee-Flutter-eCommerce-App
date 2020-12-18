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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.black,
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
          Divider(thickness: 2),
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
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Divider(thickness: 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text(
                  "Edit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  deleteButtonCallback(context);
                },
              )
            ],
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
