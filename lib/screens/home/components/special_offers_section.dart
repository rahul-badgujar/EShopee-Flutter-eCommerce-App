import 'package:flutter/material.dart';
import '../components/section_tile.dart';
import '../../../size_config.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTile(
          title: "Special for you",
          press: () {},
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                category: "Smartphone",
                image: "assets/images/Image Banner 2.png",
                numOfBrands: 18,
                press: () {},
              ),
              SpecialOfferCard(
                category: "Fasion",
                image: "assets/images/Image Banner 3.png",
                numOfBrands: 24,
                press: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  final String category;
  final String image;
  final int numOfBrands;
  final GestureTapCallback press;
  const SpecialOfferCard({
    Key key,
    @required this.category,
    @required this.image,
    @required this.numOfBrands,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: SizedBox(
        width: getProportionateScreenWidth(242),
        height: getProportionateScreenWidth(100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF343434).withOpacity(0.4),
                      Color(0xFF343434).withOpacity(0.15),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenWidth(10)),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "$category\n",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "$numOfBrands Brands"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
