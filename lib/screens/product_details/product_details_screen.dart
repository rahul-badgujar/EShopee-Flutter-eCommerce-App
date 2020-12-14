import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/details";
  @override
  Widget build(BuildContext context) {
    final ProductDetailsArugments arguments =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(
        rating: arguments.product.rating,
      ),
      body: Body(
        product: arguments.product,
      ),
    );
  }
}

class ProductDetailsArugments {
  final Product product;

  ProductDetailsArugments({@required this.product});
}
