import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class TopRoundedContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  const TopRoundedContainer({
    Key key,
    this.color = Colors.white,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(30),
        vertical: getProportionateScreenWidth(40),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(64),
          topRight: Radius.circular(64),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: child,
    );
  }
}
