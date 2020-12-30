import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  const CartItemCard({
    Key key,
    @required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(cartItem.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(88),
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      snapshot.data.images[0],
                    ),
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                        text: "\$${snapshot.data.originalPrice}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "  x${cartItem.itemCount}",
                            style: TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        } else {
          return Center(
            child: Icon(
              Icons.error,
            ),
          );
        }
      },
    );
  }
}
