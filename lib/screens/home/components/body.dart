import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/category_products/category_products_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../components/home_header.dart';
import 'product_type_box.dart';
import 'products_section.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            Flexible(flex: 2, child: HomeHeader()),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(width: 8),
                    ProductTypeBox(
                      icon: "assets/icons/Electronics.svg",
                      title: "Electronics",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Electronics,
                            ),
                          ),
                        );
                      },
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Books.svg",
                      title: "Books",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Books,
                            ),
                          ),
                        );
                      },
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Fashion.svg",
                      title: "Fashion",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Fashion,
                            ),
                          ),
                        );
                      },
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Groceries.svg",
                      title: "Groceries",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Groceries,
                            ),
                          ),
                        );
                      },
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Art.svg",
                      title: "Art",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Art,
                            ),
                          ),
                        );
                      },
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Others.svg",
                      title: "Others",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsScreen(
                              productType: ProductType.Others,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 8,
              child: ProductsSection(
                sectionTitle: "Products You Like",
                productsStream:
                    UserDatabaseHelper().usersFavouriteProductsStream,
              ),
            ),
            Flexible(
              flex: 8,
              child: ProductsSection(
                sectionTitle: "Explore All Products",
                productsStream: ProductDatabaseHelper().allProductsListStream,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
          ],
        ),
      ),
    );
  }
}
