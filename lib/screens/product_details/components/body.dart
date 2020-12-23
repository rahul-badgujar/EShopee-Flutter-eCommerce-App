import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_actions_section.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_images.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductImages(product: product),
            SizedBox(height: getProportionateScreenWidth(20)),
            ProductActionsSection(product: product),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      ),
    );
  }
}
