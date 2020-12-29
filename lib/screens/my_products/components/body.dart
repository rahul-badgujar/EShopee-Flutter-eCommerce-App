import 'package:e_commerce_app_flutter/components/product_short_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/edit_product/edit_product_screen.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

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
                child: StreamBuilder<List<Product>>(
                  stream: ProductDatabaseHelper().usersProductListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final products = snapshot.data;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return buildProductsCard(products[index]);
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
        background: buildDismissibleSecondaryBackground(),
        secondaryBackground: buildDismissiblePrimaryBackground(),
        dismissThresholds: {
          DismissDirection.endToStart: 0.65,
          DismissDirection.startToEnd: 0.65,
        },
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
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
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

              bool productInfoDeleted = false;
              String snackbarMessage;
              try {
                final deleteProductFuture =
                    ProductDatabaseHelper().deleteUserProduct(product.id);
                productInfoDeleted = await showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      deleteProductFuture,
                      message: Text("Deleting Product"),
                    );
                  },
                );
                if (productInfoDeleted == true) {
                  snackbarMessage = "Product deleted successfully";
                } else {
                  throw "Coulnd't delete product, please retry";
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
            }
            return confirmation;
          } else if (direction == DismissDirection.endToStart) {
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
          if (direction == DismissDirection.startToEnd) {
            print("delete: ${product.id}");
          } else if (direction == DismissDirection.startToEnd) {}
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
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

  Widget buildDismissibleSecondaryBackground() {
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
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
