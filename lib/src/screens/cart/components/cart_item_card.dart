import 'package:eshopee/src/models/cart_item_model.dart';
import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: ProductDatabaseHelper().getProductWithID(cartItem.id),
      builder: (context, snapshot) {
        final product = snapshot.data;
        if (product != null) {
          return Row(
            children: [
              SizedBox(
                width: Dimens.instance.percentageScreenWidth(70),
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0x0ff5f6f9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      product.images[0],
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimens.instance.percentageScreenHeight(2)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                        text: "\$${product.originalPrice}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: UiPalette.primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "  x${cartItem.itemCount}",
                            style: TextStyle(
                              color: UiPalette.textDarkShade(3),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
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
        } else {
          return const Center(
            child: Icon(
              Icons.error,
            ),
          );
        }
      },
    );
  }
}
