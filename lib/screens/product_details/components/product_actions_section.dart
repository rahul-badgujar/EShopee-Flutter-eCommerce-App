import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: ProductDescription(product: widget.product),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: buildFavouriteButton(),
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
      ],
    );
  }

  Widget buildFavouriteButton() {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      width: getProportionateScreenWidth(64),
      decoration: BoxDecoration(
        color: widget.product.favourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: SvgPicture.asset(
          "assets/icons/Heart Icon_2.svg",
          color:
              widget.product.favourite ? Color(0xFFFF4848) : Color(0xFFD8DEE4),
        ),
      ),
    );
  }
}
