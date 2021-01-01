import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/models/Review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../size_config.dart';

class ProductReviewDialog extends StatelessWidget {
  final Review review;
  ProductReviewDialog({
    Key key,
    @required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Review",
        ),
      ),
      children: [
        Center(
          child: RatingBar.builder(
            initialRating: review.rating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              review.rating = rating.round();
            },
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Center(
          child: TextFormField(
            initialValue: review.feedback,
            decoration: InputDecoration(
              hintText: "Feedback of Product",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              review.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Center(
          child: DefaultButton(
            text: "Submit",
            press: () {
              Navigator.pop(context, review);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
