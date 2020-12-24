import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/components/product_card.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/home/components/section_tile.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../components/home_header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Flexible(flex: 2, child: HomeHeader()),
            SizedBox(height: getProportionateScreenHeight(20)),
            SectionTile(
              title: "Product You Like",
              press: () {},
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Flexible(
                flex: 6,
                child: buildProductsList(
                    ProductDatabaseHelper().allProductsListStream)),
            SizedBox(height: getProportionateScreenHeight(20)),
            SectionTile(
              title: "Explore All Product",
              press: () {},
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Flexible(
                flex: 6,
                child: buildProductsList(
                    ProductDatabaseHelper().allProductsListStream)),
            SizedBox(height: getProportionateScreenHeight(10)),
          ],
        ),
      ),
    );
  }

  Widget buildProductsList(Stream stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data.docs
              .map((e) => Product.fromMap(e.data(), id: e.id))
              .toList();
          return buildHorizontalProductsList(products);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
            child: Icon(
          Icons.error,
        ));
      },
    );
  }

  Widget buildHorizontalProductsList(List<Product> products) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
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
