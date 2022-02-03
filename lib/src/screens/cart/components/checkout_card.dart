import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';

class CheckoutCard extends StatelessWidget {
  final Future<void> Function() onCheckoutPressed;
  const CheckoutCard({
    Key? key,
    required this.onCheckoutPressed,
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA).withOpacity(0.6),
            offset: const Offset(0, -15),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<num>(
                  future: UserDatabaseHelper().cartTotal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cartTotal = snapshot.data;
                      return Text.rich(
                        TextSpan(text: "Total\n", children: [
                          TextSpan(
                            text: "₹$cartTotal",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DefaultButton(
                    label: "Checkout",
                    onPressed: onCheckoutPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
          ],
        ),
      ),
    );
  }
}
