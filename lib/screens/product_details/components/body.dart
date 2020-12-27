import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/models/Review.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_actions_section.dart';
import 'package:e_commerce_app_flutter/screens/product_details/components/product_images.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({
    Key key,
    @required this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductImages(product: product),
            SizedBox(height: getProportionateScreenWidth(20)),
            ProductActionsSection(product: product),
            ProductReviewsSection(product: product),
            SizedBox(height: getProportionateScreenHeight(90)),
          ],
        ),
      ),
    );
  }
}

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(320),
      child: TopRoundedContainer(
        child: Column(
          children: [
            Text(
              "Product Reviews",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Expanded(
              child: StreamBuilder<List<Review>>(
                stream: ProductDatabaseHelper()
                    .getAllReviewsStreamForProductId(product.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final reviewsList = snapshot.data;
                    return ListView.builder(
                      itemCount: reviewsList.length,
                      itemBuilder: (context, index) {
                        return ReviewBox(
                          review: reviewsList[index],
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
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
                    return Center(
                      child: Icon(
                        Icons.error,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewBox extends StatelessWidget {
  final Review review;
  const ReviewBox({
    Key key,
    @required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kTextColor.withOpacity(0.075),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              review.feedback,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                "${review.rating}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
