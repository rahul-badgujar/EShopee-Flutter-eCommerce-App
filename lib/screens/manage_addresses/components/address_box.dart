import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

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
                onPressed: () {},
              ),
              FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
