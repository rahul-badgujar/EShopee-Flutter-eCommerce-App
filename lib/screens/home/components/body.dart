import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import '../components/home_header.dart';
import '../components/discount_banner.dart';
import '../components/categories.dart';
import '../components/special_offers_section.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenWidth(30)),
              DiscountBanner(),
              SizedBox(height: getProportionateScreenWidth(30)),
              Categories(),
              SizedBox(height: getProportionateScreenWidth(30)),
              SpecialOffersSection(),
              SizedBox(height: getProportionateScreenWidth(30)),
              //PopularProductsSection(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
