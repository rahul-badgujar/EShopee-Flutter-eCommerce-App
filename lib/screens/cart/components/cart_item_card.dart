/* import 'package:e_commerce_app_flutter/models/Cart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartItemCard extends StatelessWidget {
  final Cart cart;
  const CartItemCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(88),
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                cart.product.images[0],
              ),
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.product.title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                  text: "\$${cart.product.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                  children: [
                    TextSpan(
                      text: "  x${cart.numOfItem}",
                      style: TextStyle(
                        color: kTextColor,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ],
    );
  }
}
 */
