import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/category_products/category_products_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../components/home_header.dart';
import 'product_type_box.dart';
import 'products_section.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatelessWidget {
  final productCategories = <Map>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Electronics",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Books.svg",
      TITLE_KEY: "Books",
      PRODUCT_TYPE_KEY: ProductType.Books,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Fashion.svg",
      TITLE_KEY: "Fashion",
      PRODUCT_TYPE_KEY: ProductType.Fashion,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Groceries.svg",
      TITLE_KEY: "Groceries",
      PRODUCT_TYPE_KEY: ProductType.Groceries,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Art.svg",
      TITLE_KEY: "Art",
      PRODUCT_TYPE_KEY: ProductType.Art,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: getProportionateScreenHeight(15)),
              HomeHeader(),
              /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: [
                    ...List.generate(
                      productCategories.length,
                      (index) {
                        return ProductTypeBox(
                          icon: productCategories[index][ICON_KEY],
                          title: productCategories[index][TITLE_KEY],
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  productType: productCategories[index]
                                      [PRODUCT_TYPE_KEY],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ), */
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.5,
                child: ProductsSection(
                  sectionTitle: "Products You Like",
                  productsStream:
                      UserDatabaseHelper().usersFavouriteProductsStream,
                  emptyListMessage: "Add Product to Favourites",
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.5,
                child: ProductsSection(
                  sectionTitle: "Explore All Products",
                  productsStream: ProductDatabaseHelper().allProductsListStream,
                  emptyListMessage: "Looks like all Stores are closed",
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(80)),
            ],
          ),
        ),
      ),
    );
  }
}
