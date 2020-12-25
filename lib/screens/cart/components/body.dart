import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/product_short_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/cart/components/checkout_card.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import '../../../utils.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double cartTotal = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            "Your Cart",
            style: headingStyle,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Proceed Payment",
            press: () {
              Scaffold.of(context).showBottomSheet((context) {
                return CheckoutCard(
                  cartTotal: cartTotal,
                  onCheckoutPressed: () {},
                );
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Expanded(
            child: buildCartItemsList(),
          ),
        ],
      ),
    );
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<CartItem>>(
        stream: UserDatabaseHelper().allCartItemsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
          cartTotal = 0.0;
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              if (index >= snapshot.data.length) {
                return SizedBox(height: getProportionateScreenHeight(80));
              }
              return Dismissible(
                key: Key(snapshot.data[index].productID),
                direction: DismissDirection.startToEnd,
                dismissThresholds: {
                  DismissDirection.startToEnd: 0.65,
                },
                background: buildDismissibleBackground(),
                child: buildCartItem(snapshot.data[index]),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    final confirmation = await showConfirmationDialog(
                      context,
                      "Remove Product from Cart?",
                    );
                    if (confirmation) {}
                    return confirmation;
                  }
                  return false;
                },
                onDismissed: (direction) {
                  print("Cart item delete request");
                },
              );
            },
          );
        });
  }

  Widget buildCartItem(CartItem cartItem) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(cartItem.productID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
          cartTotal += (cartItem.itemCount * snapshot.data.discountPrice);
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: ProductShortDetailCard(
                  product: snapshot.data,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: snapshot.data,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: kTextColor,
                        ),
                        onTap: () {},
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${cartItem.itemCount}",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: kTextColor,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
