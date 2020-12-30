import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwipeDetector(
          onSwipeLeft: () {
            setState(
              () {
                selectedImage++;
                selectedImage %= widget.product.images.length;
              },
            );
          },
          onSwipeRight: () {
            setState(
              () {
                selectedImage--;
                selectedImage += widget.product.images.length;
                selectedImage %= widget.product.images.length;
              },
            );
          },
          child: PinchZoomImage(
            hideStatusBarWhileZooming: true,
            image: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: SizedBox(
                height: SizeConfig.screenHeight * 0.35,
                width: SizeConfig.screenWidth * 0.75,
                child: Image.network(
                  widget.product.images[selectedImage],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              widget.product.images.length,
              (index) => buildSmallPreview(index: index),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSmallPreview({@required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
        padding: EdgeInsets.all(getProportionateScreenHeight(8)),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  selectedImage == index ? kPrimaryColor : Colors.transparent),
        ),
        child: Image.network(widget.product.images[index]),
      ),
    );
  }
}
