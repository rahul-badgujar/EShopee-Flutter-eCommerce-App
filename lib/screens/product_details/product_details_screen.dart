import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(
        rating: product.rating,
      ),
      body: Body(
        product: product,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool addedSuccessfully = false;
          String snackbarMessage;
          try {
            addedSuccessfully = await UserDatabaseHelper().addProductToCart(
              CartItem(
                productID: product.id,
                itemCount: 1,
              ),
            );
            if (addedSuccessfully == true) {
              snackbarMessage = "Product added successfully";
            } else {
              throw "Coulnd't add product due to unknown reason";
            }
          } on FirebaseException catch (e) {
            Logger().w("Firebase Exception: $e");
            snackbarMessage = "Something went wrong";
          } catch (e) {
            Logger().w("Unknown Exception: $e");
            snackbarMessage = "Something went wrong";
          } finally {
            Logger().i(snackbarMessage);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snackbarMessage),
              ),
            );
          }
        },
        label: Text(
          "Add to Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: Icon(
          Icons.shopping_cart,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
