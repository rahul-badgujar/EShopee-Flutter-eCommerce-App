/* import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool showFullDescription = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              maxLines: showFullDescription ? null : 3,
              textAlign: TextAlign.left,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showFullDescription ^= true;
                });
              },
              child: Row(
                children: [
                  Text(
                    showFullDescription == false
                        ? "See more details"
                        : "Show less details",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}
 */
