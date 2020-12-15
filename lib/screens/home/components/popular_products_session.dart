import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import '../components/section_tile.dart';
import '../../../size_config.dart';
import '../../../models/Product.dart';
import '../../../components/product_card.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTile(
          title: "Popular Products",
          press: () {},
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              demoProducts.length,
              (index) => ProductCard(
                product: demoProducts[index],
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: demoProducts[index]),
                      ));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
