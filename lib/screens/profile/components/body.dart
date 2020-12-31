import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

import 'display_pic.dart';
import 'profile_menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              DisplayPicture(),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProfileMenu(
                text: "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () {},
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProfileMenu(
                text: "Notifications",
                icon: "assets/icons/Bell.svg",
                press: () {},
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProfileMenu(
                text: "Settings",
                icon: "assets/icons/Settings.svg",
                press: () {},
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProfileMenu(
                text: "Sign Out",
                icon: "assets/icons/Log out.svg",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
