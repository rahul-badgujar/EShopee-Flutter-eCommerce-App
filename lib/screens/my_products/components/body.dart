import 'package:e_commerce_app_flutter/components/product_short_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/edit_product/edit_product_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import '../../../utils.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Text("Your Products", style: headingStyle),
              Text(
                "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              Expanded(
                child: FutureBuilder(
                  future: ProductDatabaseHelper().getUsersProductsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return buildProductsCard(snapshot.data[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Icon(Icons.error);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildProductsCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: Key(product.id),
        direction: DismissDirection.horizontal,
        background: buildDismissiblePrimaryBackground(),
        secondaryBackground: buildDismissibleSecondaryBackground(),
        child: ProductShortDetailCard(
          product: product,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final confirmation = await showConfirmationDialog(
                context, "Are you sure to Delete Product?");
            if (confirmation) {
              for (int i = 0; i < product.images.length; i++) {
                String path = ProductDatabaseHelper()
                    .getPathForProductImage(product.id, i);
                final deletionFuture =
                    FirestoreFilesAccess().deleteFileFromPath(path);
                await showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      deletionFuture,
                      message: Text(
                          "Deleting Product Images ${i + 1}/${product.images.length}"),
                    );
                  },
                );
              }
              final deleteProductFuture =
                  ProductDatabaseHelper().deleteUserProduct(product.id);
              await showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    deleteProductFuture,
                    message: Text("Deleting Product"),
                  );
                },
              );
            }
            return confirmation;
          } else if (direction == DismissDirection.startToEnd) {
            final confirmation = await showConfirmationDialog(
                context, "Are you sure to Edit Product?");
            if (confirmation) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                    productToEdit: product,
                  ),
                ),
              );
            }
            return false;
          }
          return false;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            print("delete: ${product.id}");
          } else if (direction == DismissDirection.startToEnd) {}
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
