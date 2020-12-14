import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_description.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_images.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Stack(
              children: [
                TopRoundedContainer(
                  child: ProductDescription(product: product),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: buildFavouriteButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFavouriteButton() {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      width: getProportionateScreenWidth(64),
      decoration: BoxDecoration(
        color: product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: SvgPicture.asset(
          "assets/icons/Heart Icon_2.svg",
          color: product.isFavourite ? Color(0xFFFF4848) : Color(0xFFD8DEE4),
        ),
      ),
    );
  }
}
