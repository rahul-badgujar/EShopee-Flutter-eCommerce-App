import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "About Developer",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                CircleAvatar(
                  radius: SizeConfig.screenWidth * 0.3,
                  backgroundColor: kTextColor.withOpacity(0.5),
                  backgroundImage: AssetImage(
                    "assets/images/developer.jpeg",
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  '" Rahul Badgujar "',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "PCCoE Pune",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(75)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      padding: EdgeInsets.all(16),
                      onPressed: () {},
                    ),
                    Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      padding: EdgeInsets.all(16),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
