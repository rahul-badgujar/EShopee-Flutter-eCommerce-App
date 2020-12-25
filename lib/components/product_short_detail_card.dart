import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductShortDetailCard extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;
  const ProductShortDetailCard({
    Key key,
    @required this.product,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(88),
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: product.images.length > 0
                    ? Image.network(
                        product.images[0],
                        fit: BoxFit.contain,
                      )
                    : Text("No Image"),
              ),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                      text: "\₹${product.discountPrice}    ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "\₹${product.originalPrice}",
                          style: TextStyle(
                            color: kTextColor,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
