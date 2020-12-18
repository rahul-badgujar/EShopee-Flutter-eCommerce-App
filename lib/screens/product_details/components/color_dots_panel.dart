/* import 'package:e_commerce_app_flutter/components/top_rounded_container.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ColorDotsPanel extends StatefulWidget {
  const ColorDotsPanel({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ColorDotsPanelState createState() => _ColorDotsPanelState();
}

class _ColorDotsPanelState extends State<ColorDotsPanel> {
  int selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return TopRoundedContainer(
      color: Color(0xFFF6F7F9),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                widget.product.colors.length,
                (index) => ColorDot(
                  color: widget.product.colors[index],
                  isSelected: selectedColor == index,
                ),
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(24),
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorDot({
    Key key,
    @required this.color,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.all(4),
      width: getProportionateScreenWidth(36),
      height: getProportionateScreenWidth(36),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? kPrimaryColor : Colors.transparent,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
 */
