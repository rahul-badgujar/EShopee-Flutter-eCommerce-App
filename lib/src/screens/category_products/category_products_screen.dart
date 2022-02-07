import 'package:eshopee/src/models/product_model.dart';

import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryProductsScreen extends StatelessWidget {
  static const ROUTE_NAME = '/category-product-screen';

  // keys for route args
  static const KEY_PRODUCT_TYPE = 'product-type';

  final ProductType productType;

  const CategoryProductsScreen({
    Key? key,
    required this.productType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        productType: productType,
      ),
    );
  }
}
