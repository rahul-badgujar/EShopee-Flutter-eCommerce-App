import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProductShortDetailCard extends StatelessWidget {
  final String productId;
  final VoidCallback onPressed;
  const ProductShortDetailCard({
    Key? key,
    required this.productId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Product?>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          final product = snapshot.data;
          if (product != null) {
            return Row(
              children: [
                SizedBox(
                  width: Dimens.instance.percentageScreenWidth(22),
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: product.images.isNotEmpty
                          ? Image.network(
                              product.images[0],
                              fit: BoxFit.contain,
                            )
                          : const Text("No Image"),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.instance.percentageScreenHeight(1)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: UiPalette.textDarkShade(3),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                            text: "₹${product.discountPrice}    ",
                            style: TextStyle(
                              color: UiPalette.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: "₹${product.originalPrice}",
                                style: TextStyle(
                                  color: UiPalette.textDarkShade(3),
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: UiPalette.textDarkShade(3),
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
