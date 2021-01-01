import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_actions_section.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_images.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'product_review_section.dart';

class Body extends StatelessWidget {
  final String productId;

  const Body({
    Key key,
    @required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data;
                return Column(
                  children: [
                    ProductImages(product: product),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductActionsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductReviewsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(100)),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
            },
          ),
        ),
      ),
    );
  }
}
