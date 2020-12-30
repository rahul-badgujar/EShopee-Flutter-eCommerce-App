import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key key,
    @required this.addressId,
    @required this.deleteButtonCallback,
    @required this.editButtonCallback,
  }) : super(key: key);

  final String addressId;
  final Function deleteButtonCallback;
  final Function editButtonCallback;

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
              child: FutureBuilder<Address>(
                  future: UserDatabaseHelper().getAddressFromId(addressId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data;
                      return Column(
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
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      final error = snapshot.error.toString();
                      Logger().e(error);
                    }
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: kTextColor,
                        size: 60,
                      ),
                    );
                  }),
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
                    editButtonCallback.call(context, addressId);
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
                    deleteButtonCallback.call(context, addressId);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
