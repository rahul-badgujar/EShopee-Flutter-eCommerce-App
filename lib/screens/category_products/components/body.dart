import 'dart:math';

import 'package:e_commerce_app_flutter/components/product_card.dart';
import 'package:e_commerce_app_flutter/components/rounded_icon_button.dart';
import 'package:e_commerce_app_flutter/components/search_field.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class Body extends StatelessWidget {
  final ProductType productType;

  Body({
    Key key,
    @required this.productType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedIconButton(
                    iconData: Icons.arrow_back_ios,
                    press: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 5),
                  Expanded(child: SearchField()),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream:
                      ProductDatabaseHelper().getCategoryProducts(productType),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Product> products = snapshot.data;
                      int uptoDiscount = 0;
                      products.forEach(
                        (product) {
                          uptoDiscount = max(uptoDiscount,
                              product.calculatePercentageDiscount());
                        },
                      );
                      return Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: buildCategoryBanner(uptoDiscount),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Expanded(
                            flex: 10,
                            child: buildProductsGrid(products),
                          ),
                        ],
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
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryBanner(int uptoDiscount) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bannerFromProductType()),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                kPrimaryColor,
                BlendMode.hue,
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text.rich(
              TextSpan(
                text: EnumToString.convertToString(productType),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
                children: [
                  TextSpan(
                    text: "\nUpto $uptoDiscount% Off",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductsGrid(List<Product> products) {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: products[index],
                ),
              ),
            );
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 2,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 12,
      ),
    );
  }

  String bannerFromProductType() {
    switch (productType) {
      case ProductType.Electronics:
        return "assets/images/electronics_banner.jpg";
      case ProductType.Books:
        return "assets/images/books_banner.jpg";
      case ProductType.Fashion:
        return "assets/images/fashions_banner.jpg";
      case ProductType.Groceries:
        return "assets/images/groceries_banner.jpg";
      case ProductType.Art:
        return "assets/images/arts_banner.jpg";
      case ProductType.Others:
        return "assets/images/others_banner.jpg";
      default:
        return "assets/images/others_banner.jpg";
    }
  }
}
