import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NothingToShowContainer {
  static Widget emptyCart() {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.75,
      height: SizeConfig.screenHeight * 0.3,
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/icons/empty_cart.svg",
            color: kTextColor,
            width: getProportionateScreenWidth(75),
          ),
          SizedBox(height: 16),
          Text(
            "Nothing to show",
            style: TextStyle(
              color: kTextColor,
              fontSize: 15,
            ),
          ),
          Text(
            "Your cart is Empty",
            style: TextStyle(
              color: kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget error({String message = "Can't connect to Database"}) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.75,
      height: SizeConfig.screenHeight * 0.3,
      child: Column(children: [
        SvgPicture.asset(
          "assets/icons/network_error.svg",
          color: kTextColor,
          width: getProportionateScreenWidth(75),
        ),
        SizedBox(height: 16),
        Text(
          "Something went wrong",
          style: TextStyle(
            color: kTextColor,
            fontSize: 15,
          ),
        ),
        Text(
          "$message",
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}
