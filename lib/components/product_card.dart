import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import '../constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final GestureTapCallback press;
  const ProductCard({
    Key key,
    @required this.productId,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Product product = snapshot.data;
                return buildProductCardItems(product);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Column buildProductCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              product.images[0],
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  "${product.title}\n",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text.rich(
                        TextSpan(
                          text: "\₹${product.discountPrice}\n",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: "\₹${product.originalPrice}",
                              style: TextStyle(
                                color: kTextColor,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/DiscountTag.svg",
                            color: kPrimaryColor,
                          ),
                          Center(
                            child: Text(
                              "${product.calculatePercentageDiscount()}%\nOff",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
