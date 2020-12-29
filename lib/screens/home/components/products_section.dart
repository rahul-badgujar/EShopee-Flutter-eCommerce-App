import 'package:e_commerce_app_flutter/components/product_card.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/home/components/section_tile.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../size_config.dart';

class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final Stream productsStream;
  const ProductsSection({
    Key key,
    @required this.sectionTitle,
    @required this.productsStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTile(
          title: sectionTitle,
          press: () {},
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        Expanded(
          child: buildProductsList(productsStream),
        ),
      ],
    );
  }

  Widget buildProductsList(Stream stream) {
    return StreamBuilder<List<Product>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildHorizontalProductsList(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  Widget buildHorizontalProductsList(List<Product> products) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          press: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(product: products[index]),
              ),
            );
          },
        );
      },
      itemExtent: SizeConfig.screenWidth * 0.46,
      padding: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
