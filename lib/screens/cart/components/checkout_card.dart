import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  final double cartTotal;
  final VoidCallback onCheckoutPressed;
  const CheckoutCard({
    Key key,
    @required this.cartTotal,
    @required this.onCheckoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDADADA).withOpacity(0.6),
            offset: Offset(0, -15),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(text: "Total\n", children: [
                    TextSpan(
                      text: "\₹$cartTotal",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Checkout",
                    press: onCheckoutPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
