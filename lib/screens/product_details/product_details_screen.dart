import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/details";
  final Product product;

  const ProductDetailsScreen({Key key, @required this.product})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(product.productType);
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(
        rating: product.rating,
      ),
      body: Body(
        product: product,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
