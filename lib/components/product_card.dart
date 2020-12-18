/* import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../size_config.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final GestureTapCallback press;
  const ProductCard({
    Key key,
    @required this.product,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: InkWell(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(140),
          height: getProportionateScreenWidth(220),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.title,
                    child: Image.asset(product.images[0]),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product.title}\n",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(8)),
                          width: getProportionateScreenWidth(28),
                          height: getProportionateScreenWidth(28),
                          decoration: BoxDecoration(
                            color: product.isFavourite
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/Heart Icon_2.svg",
                            color: product.isFavourite
                                ? Color(0xFFFF4848)
                                : Color(0xFFDBDEE4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */
