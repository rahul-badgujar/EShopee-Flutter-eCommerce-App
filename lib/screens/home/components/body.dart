import 'package:e_commerce_app_flutter/components/product_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/category_products/category_products_screen.dart';
import 'package:e_commerce_app_flutter/screens/home/components/section_tile.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
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

class ProductTypeBox extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPress;
  const ProductTypeBox({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: kPrimaryColor.withOpacity(0.18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(
                    icon,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenHeight(8),
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
