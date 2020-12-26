import 'package:e_commerce_app_flutter/components/product_short_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/OrderedProduct.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

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
              "Your Orders",
              style: headingStyle,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Expanded(
              child: buildOrderedProductsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<OrderedProduct>>(
      stream: UserDatabaseHelper().orderedProductsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Icon(Icons.error));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final orderedProductsList = snapshot.data;
        return ListView.builder(
          itemCount: orderedProductsList.length,
          itemBuilder: (context, index) {
            return buildOrderedProductItem(orderedProductsList, index);
          },
        );
      },
    );
  }

  Widget buildOrderedProductItem(
      List<OrderedProduct> orderedProductsList, int index) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper()
          .getProductWithID(orderedProductsList[index].productUid),
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Icon(Icons.error));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final product = snapshot.data;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kTextColor.withOpacity(0.18),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    text: "Ordered on:  ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: orderedProductsList[index].orderDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(
                      color: kTextColor.withOpacity(0.15),
                    ),
                  ),
                ),
                child: ProductShortDetailCard(
                  product: product,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Give Product Review",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
