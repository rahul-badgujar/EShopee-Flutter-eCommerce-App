import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'color_dots_panel.dart';

class ProductActionsSection extends StatefulWidget {
  final Product product;

  const ProductActionsSection({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  _ProductActionsSectionState createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  int itemsToAdd = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: Column(
                children: [
                  ProductDescription(product: widget.product),
                  ColorDotsPanel(product: widget.product),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: buildFavouriteButton(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.add_circle_rounded),
                onPressed: () {
                  setState(() {
                    itemsToAdd++;
                  });
                },
                color: kPrimaryColor,
                iconSize: getProportionateScreenWidth(60),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.remove_circle_rounded),
                onPressed: () {
                  if (itemsToAdd > 0) {
                    setState(() {
                      itemsToAdd--;
                    });
                  }
                },
                color: kPrimaryColor,
                iconSize: getProportionateScreenWidth(60),
              ),
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        DefaultButton(
          text: "Add $itemsToAdd items to Cart",
          press: () {},
        ),
      ],
    );
  }

  Widget buildFavouriteButton() {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      width: getProportionateScreenWidth(64),
      decoration: BoxDecoration(
        color:
            widget.product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: SvgPicture.asset(
          "assets/icons/Heart Icon_2.svg",
          color: widget.product.isFavourite
              ? Color(0xFFFF4848)
              : Color(0xFFD8DEE4),
        ),
      ),
    );
  }
}
